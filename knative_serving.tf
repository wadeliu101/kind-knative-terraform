resource "null_resource" "install_knative_serving" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/knative/serving/releases/download/${var.KNATIVE_VERSION}/serving-crds.yaml"
  }
  provisioner "local-exec" {
    command = "kubectl wait --for=condition=Established --all crd"
  }
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/knative/serving/releases/download/${var.KNATIVE_VERSION}/serving-core.yaml"
  }
  provisioner "local-exec" {
    command = "kubectl wait deployment --all --timeout=-1s --for=condition=Available -n knative-serving"
  }
  depends_on = [ kind_cluster.knative ]
}