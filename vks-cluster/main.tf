data "vcfa_org" "existing" {
  name = var.vcfa_org
}

data "vcfa_region" "one" {
  name = var.vcfa_region
}


data "vcfa_storage_class" "sc" {
  region_id = data.vcfa_region.one.id
  name      = "vSAN Default Storage Policy"
}

resource "kubernetes_manifest" "kubernetes_cluster" {
  manifest = {
    "apiVersion" = "cluster.x-k8s.io/v1beta1"
    "kind"       = "Cluster"
    "metadata" = {
      "name"      = "${var.cluster_name}"
      "namespace" = "${var.supervisor_namespace_name}"
    }
    "spec" = {
      "clusterNetwork" = {
        "pods" = {
          "cidrBlocks" = [
            "192.168.156.0/20",
          ]
        }
        "serviceDomain" = "cluster.local"
        "services" = {
          "cidrBlocks" = [
            "10.96.0.0/12",
          ]
        }
      }
      "topology" = {
        "class" = "builtin-generic-v3.3.0"
        "controlPlane" = {
          "replicas" = 1
        }
        "variables" = [
          {
            "name" = "vsphereOptions"
            "value" = {
              "persistentVolumes" = {
                "availableStorageClasses" = [
                  "vsan-default-storage-policy",
                ]
                "defaultStorageClass" = "vsan-default-storage-policy"
              }
            }
          },
          {
            "name" = "kubernetes"
            "value" = {
              "certificateRotation" = {
                "enabled"                 = true
                "renewalDaysBeforeExpiry" = 90
              }
            }
          },
          {
            "name"  = "vmClass"
            "value" = "best-effort-large"
          },
          {
            "name"  = "storageClass"
            "value" = "vsan-default-storage-policy"
          },
        ]
        "version" = "v1.32.0+vmware.6-fips"
        "workers" = {
          "machineDeployments" = [
            {
              "class"    = "node-pool"
              "name"     = "demo-node-pool"
              "replicas" = 3
            },
          ]
        }
      }
    }
  }
}
