resource "kubernetes_manifest" "music-store" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name = "music-store"
      namespace = "${var.supervisor_namespace_name}" 
    }
    spec = {
      project = "default"
      source = {
        repoURL = "https://github.com/NiranEC77/example-music-store-1"
        path = "./"
        targetRevision = "main"
        directory = {
          include = "k8s-*.yaml"
        }
      }
      destination = {
        server = "https://10.21.10.2:6443"
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
