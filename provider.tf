terraform {
  required_providers {
    kind = {
      source = "unicell/kind"
      version = "0.0.2-u2"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.0.2"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.0.2"
    }
  }
}

provider "kubernetes" {
  config_path = kind_cluster.knative.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = kind_cluster.knative.kubeconfig_path
  }
}