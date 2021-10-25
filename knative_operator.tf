resource "null_resource" "knative-operator" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/knative/operator/releases/download/v${var.KNATIVE_VERSION}/operator.yaml"
  }
  depends_on = [
    time_sleep.wait_istio_ready
  ]
}