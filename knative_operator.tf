resource "null_resource" "knative-operator" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/knative/operator/releases/download/knative-v${var.KNATIVE_VERSION}/operator.yaml"
  }
  depends_on = [
    module.kind-istio-metallb
  ]
}
