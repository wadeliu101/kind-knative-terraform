resource "kubernetes_namespace" "knative-eventing" {
  metadata {
    name = "knative-eventing"
  }
  depends_on = [
    null_resource.configure_dns_for_knative_serving
  ]
}
resource "local_file" "knative-eventing" {
  content = <<-EOF
  apiVersion: operator.knative.dev/v1alpha1
  kind: KnativeEventing
  metadata:
    name: knative-eventing
  spec:
    version: ${var.KNATIVE_VERSION}
    manifests:
    - URL: https://github.com/knative/eventing/releases/download/v$${VERSION}/eventing.yaml
    - URL: https://github.com/knative/eventing/releases/download/v$${VERSION}/eventing-post-install-jobs.yaml
    source:
      natss:
        enabled: true
  EOF
  filename = "${path.root}/configs/knative-eventing.yaml"
  provisioner "local-exec" {
    command = "kubectl apply -f ${self.filename} -n ${kubernetes_namespace.knative-eventing.metadata[0].name}"
  }
}
resource "time_sleep" "wait_knative_eventing_ready" {
  create_duration = "30s"
  provisioner "local-exec" {
    command = "kubectl wait deployment --all --timeout=-1s --for=condition=Available -n ${kubernetes_namespace.knative-eventing.metadata[0].name}"
  }
  depends_on = [
    local_file.knative-eventing
  ]
}
resource "helm_release" "nats-streaming" {
  name       = "nats-stan"
  repository = "https://nats-io.github.io/k8s/helm/charts/"
  chart      = "stan"
  version    = var.NATS_STAN_VERSION
  namespace  = "natss"
  values = [
    <<EOF
    stan:
      clusterID: knative-nats-streaming
      logging:
        debug: true
        trace: true
    nameOverride: nats-streaming
    store:
      volume:
        storageClass: standard
    EOF
  ]
  force_update     = true
  create_namespace = true
  depends_on = [time_sleep.wait_knative_eventing_ready]
}
resource "null_resource" "install_the_nats_streaming_channel" {
  provisioner "local-exec" {
    command = "kubectl apply --filename https://github.com/knative-sandbox/eventing-natss/releases/download/v${var.KNATIVE_VERSION}/eventing-natss.yaml"
  }
  provisioner "local-exec" {
    command = "kubectl wait deployment --all --timeout=-1s --for=condition=Available -n ${kubernetes_namespace.knative-eventing.metadata[0].name}"
  }
  depends_on = [helm_release.nats-streaming]
}
