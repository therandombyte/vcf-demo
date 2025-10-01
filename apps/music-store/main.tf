data "vcfa_project" "one" {
  name = var.vcfa_project
}

data "git_repo" "repo" {
  name = var.git_repo
}

resource "kubernetes_manifest" "music-store" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name = "music-store"
      namespace = module.supervisor_namespace.namespace
    }
    spec = {
      project = data.vcfa_project.one.name
      source = {
        repoURL = data.git_repo.repo.name
        path = "./"
        targetRevision = "main"
        directory = {
          include = "k8s-*.yaml"
        }
      }
      destination = {
        server = local.kubeconfig["clusters"][0]["cluster"]["server"]
        namespace = "default"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
}
