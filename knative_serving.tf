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
resource "local_file" "istio-peerAuthentication" {
  content  = <<-EOF
  apiVersion: "security.istio.io/v1beta1"
  kind: "PeerAuthentication"
  metadata:
    name: "default"
  spec:
    mtls:
      mode: PERMISSIVE
  EOF
  filename = "${path.root}/configs/istio-peerAuthentication.yaml"
  provisioner "local-exec" {
    command = "kubectl apply -f ${self.filename} -n ${kubernetes_namespace.knative-serving.metadata[0].name}"
  }
}
resource "local_file" "knative-serving" {
  content = <<-EOF
  apiVersion: operator.knative.dev/v1alpha1
  kind: KnativeServing
  metadata:
    name: knative-serving
  spec:
    version: ${var.KNATIVE_VERSION}
    manifests:
    - URL: https://github.com/knative/serving/releases/download/v$${VERSION}/serving-core.yaml
    - URL: https://github.com/knative/serving/releases/download/v$${VERSION}/serving-hpa.yaml
    - URL: https://github.com/knative/serving/releases/download/v$${VERSION}/serving-post-install-jobs.yaml
    - URL: https://github.com/knative/net-istio/releases/download/v$${VERSION}/net-istio.yaml
  EOF
  filename = "${path.root}/configs/knative-serving.yaml"
  provisioner "local-exec" {
    command = "kubectl apply -f ${self.filename} -n ${kubernetes_namespace.knative-serving.metadata[0].name}"
  }
  depends_on = [
    local_file.knative-serving
  ]
}
resource "time_sleep" "wait_knative_serving_ready" {
  create_duration = "60s"
  provisioner "local-exec" {
    command = "kubectl wait deployment --all --timeout=-1s --for=condition=Available -n ${kubernetes_namespace.knative-serving.metadata[0].name}"
  }
  depends_on = [
    local_file.knative-serving
  ]
}
resource "null_resource" "configure_dns_for_knative_serving" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/knative/serving/releases/download/v${var.KNATIVE_VERSION}/serving-default-domain.yaml"
  }
  provisioner "local-exec" {
    command = "kubectl patch configmap -n ${kubernetes_namespace.knative-serving.metadata[0].name} config-domain -p '{\"data\": {\"127.0.0.1.sslip.io\": \"\"}}'"
  }
  depends_on = [
    time_sleep.wait_knative_serving_ready
  ]
}