resource "null_resource" "installing-istio-operator" {
  provisioner "local-exec" {
    command = "istioctl operator init"
  }

  depends_on = [ null_resource.install_knative_serving ]
}

resource "null_resource" "installing-istio" {
  provisioner "local-exec" {
    command = "kubectl apply -f ./istio-profile.yaml --wait=true"
  }

  provisioner "local-exec" {
    command = "kubectl wait --timeout=-1s --for=condition=Established --all crd"
  }

  provisioner "local-exec" {
    command = "sleep 10; kubectl wait --timeout=-1s --for=condition=Available --all -n istio-system deployments"
  }
  provisioner "local-exec" {
    command = "kubectl apply -f ./istio-peerAuthentication.yaml --wait=true"
  }

  provisioner "local-exec" {
    command = "kubectl label namespace knative-serving istio-injection=enabled"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/knative/net-istio/releases/download/${var.KNATIVE_VERSION}/net-istio.yaml"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete -f ./istio-profile.yaml"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete namespace istio-system"
  }

  depends_on = [ null_resource.installing-istio-operator ]
}
resource "null_resource" "configure_dns_for_knative_serving" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/knative/serving/releases/download/${var.KNATIVE_VERSION}/serving-default-domain.yaml"
  }

  provisioner "local-exec" {
    command = "kubectl patch configmap -n knative-serving config-domain -p '{\"data\": {\"127.0.0.1.sslip.io\": \"\"}}'"
  }
  depends_on = [ null_resource.installing-istio ]
}