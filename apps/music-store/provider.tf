terraform {
  required_providers {
    vcfa = {
      source  = "vmware/vcfa"
      version = "~> 1.0.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

# VCFA Provider to connect to VCF9
provider "vcfa" {
  user                 = var.vcfa_username
  password             = var.vcfa_password
  url                  = var.vcfa_url
  org                  = var.vcfa_org
  allow_unverified_ssl = "true"
  logging              = true
}

# Leveraging the Kubernetes provider to create VMs and VKS cluster 
# as VCF is exposed  as a kubernetes endpoint
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "engg:engg-wjlr5"
}

data "vcfa_kubeconfig" "kube_config" {
  project_name              = var.vcfa_project
  supervisor_namespace_name = var.supervisor_namespace_name
}

