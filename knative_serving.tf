resource "kubernetes_namespace" "knative-serving" {
  metadata {
    name = "knative-serving"
    labels = {
      "istio-injection" = "enabled"
    }
  }
  depends_on = [
    null_resource.knative-operator
  ]
}
resource "kubectl_manifest" "istio-peerAuthentication" {
  yaml_body = <<-EOF
  apiVersion: "security.istio.io/v1beta1"
  kind: "PeerAuthentication"
  metadata:
    name: "default"
  spec:
    mtls:
      mode: PERMISSIVE
  EOF
  override_namespace = kubernetes_namespace.knative-serving.metadata[0].name
}
resource "kubectl_manifest" "knative-serving" {
  yaml_body = <<-EOF
  apiVersion: operator.knative.dev/v1alpha1
  kind: KnativeServing
  metadata:
    name: knative-serving
  EOF
  override_namespace = kubernetes_namespace.knative-serving.metadata[0].name
}
resource "time_sleep" "wait_knative_serving_ready" {
  create_duration = "60s"
  provisioner "local-exec" {
    command = "kubectl wait deployment --all --timeout=-1s --for=condition=Available -n ${kubernetes_namespace.knative-serving.metadata[0].name}"
  }
  depends_on = [
    kubectl_manifest.knative-serving
  ]
}
resource "null_resource" "configure_dns_for_knative_serving" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/knative/serving/releases/download/knative-v${var.KNATIVE_VERSION}/serving-default-domain.yaml"
  }
  provisioner "local-exec" {
    command = "kubectl patch configmap -n ${kubernetes_namespace.knative-serving.metadata[0].name} config-domain -p '{\"data\": {\"${module.kind-istio-metallb.ingress_ip_address}.sslip.io\": \"\"}}'"
  }
  depends_on = [
    time_sleep.wait_knative_serving_ready
  ]
}