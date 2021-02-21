resource "kind_cluster" "knative" {
  name = "knative"
  node_image = "kindest/node:v1.20.2@sha256:8f7ea6e7642c0da54f04a7ee10431549c0257315b3a634f6ef2fecaaedb19bab"
  kind_config = <<KIONF
    kind: Cluster
    apiVersion: kind.x-k8s.io/v1alpha4
    nodes:
    - role: control-plane
      extraPortMappings:
      - containerPort: 31080
        hostPort: 80
  KIONF
  wait_for_ready = true

  provisioner "local-exec" {
    when    = destroy
    command = "rm ${self.kubeconfig_path}"
  }
}