resource "null_resource" "install_knative_eventing" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/knative/eventing/releases/download/${var.KNATIVE_EVENTING_VERSION}/eventing-crds.yaml"
  }
  provisioner "local-exec" {
    command = "kubectl wait --for=condition=Established --all crd"
  }
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/knative/eventing/releases/download/${var.KNATIVE_EVENTING_VERSION}/eventing-core.yaml"
  }
  provisioner "local-exec" {
    command = "kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n knative-eventing"
  }
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/knative/eventing/releases/download/${var.KNATIVE_EVENTING_VERSION}/in-memory-channel.yaml"
  }
  provisioner "local-exec" {
    command = "kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n knative-eventing"
  }
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/knative/eventing/releases/download/${var.KNATIVE_EVENTING_VERSION}/mt-channel-broker.yaml"
  }
  provisioner "local-exec" {
    command = "kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n knative-eventing"
  }

  depends_on = [ null_resource.configure_knative_to_use_kourier ]
}