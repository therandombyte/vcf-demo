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
  host     = data.vcfa_kubeconfig.kube_config.host
  insecure = data.vcfa_kubeconfig.kube_config.insecure_skip_tls_verify
  token    = data.vcfa_kubeconfig.kube_config.token
}

data "vcfa_kubeconfig" "kube_config" {
  project_name              = var.vcfa_project
  supervisor_namespace_name = var.supervisor_namespace_name
}

provider "local" {
}
