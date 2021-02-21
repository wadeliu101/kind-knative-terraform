resource "null_resource" "install_knative_layer_kourier" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/knative/net-kourier/releases/download/${var.KNATIVE_VERSION}/kourier.yaml"
  }
  provisioner "local-exec" {
    command = "kubectl wait --for=condition=Established --all crd"
  }
  provisioner "local-exec" {
    command = "kubectl wait deployment --all --timeout=-1s --for=condition=Available -n kourier-system"
  }
  provisioner "local-exec" {
    command = "kubectl wait deployment --all --timeout=-1s --for=condition=Available -n knative-serving"
  }
  depends_on = [ null_resource.install_knative_serving ]
}

resource "null_resource" "configure_dns_for_knative_serving" {
  provisioner "local-exec" {
    command = "kubectl patch configmap -n knative-serving config-domain -p '{\"data\": {\"127.0.0.1.nip.io\": \"\"}}'"
  }
  depends_on = [ null_resource.install_knative_layer_kourier ]
}

resource "null_resource" "delete_kourier_service_for_update_later" {
  provisioner "local-exec" {
    command = "kubectl delete service -n kourier-system kourier --wait=true"
  }
  depends_on = [ null_resource.configure_dns_for_knative_serving ]
}

resource "kubernetes_service" "kourier_service" {
  metadata {
    name      = "kourier"
    namespace = "kourier-system"

    labels = {
      "networking.knative.dev/ingress-provider" = "kourier"
    }
  }

  spec {
    port {
      name        = "http2"
      port        = 80
      target_port = "8080"
      node_port   = 31080
    }

    selector = {
      app = "3scale-kourier-gateway"
    }

    type = "NodePort"
  }
  depends_on = [ null_resource.delete_kourier_service_for_update_later ]
}

resource "null_resource" "configure_knative_to_use_kourier" {
  provisioner "local-exec" {
    command = "kubectl patch configmap -n knative-serving config-network --type merge --patch '{\"data\":{\"ingress.class\":\"kourier.ingress.networking.knative.dev\"}}'"
  }
  depends_on = [ kubernetes_service.kourier_service ]
}
