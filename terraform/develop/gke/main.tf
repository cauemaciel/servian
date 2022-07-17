module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id                 = "topgun-servian"
  name                       = "k8s-development"
  region                     = "us-east1"
  zones                      = ["us-east1-b", "us-east1-c"]
  network                    = "dev-vpc"
  subnetwork                 = "dev-subnet-01"
  ip_range_pods              = "dev-subnet-01-pods-secondary"
  ip_range_services          = "dev-subnet-01-service-secondary"
  remove_default_node_pool   = true
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = true
  enable_private_endpoint    = false
  enable_private_nodes       = true
  master_ipv4_cidr_block     = "172.20.0.96/28"

  node_pools = [
    {
      name               = "development-node-pool-application"
      machine_type       = "n1-standard-2"
      min_count          = 1
      max_count          = 3
      disk_size_gb       = 50
      disk_type          = "pd-standard"
      image_type         = "cos_containerd"
      auto_repair        = true
      auto_upgrade       = true
#      service_account    = "tf-gke-k8s-production-0njj@xstaging-348615.iam.gserviceaccount.com"
      preemptible        = true
      initial_node_count = 1
    },
    {
      name               = "development-node-pool-management" 
      machine_type       = "n1-standard-2"
      min_count          = 1
      max_count          = 3
      disk_size_gb       = 50
      disk_type          = "pd-standard"
      image_type         = "cos_containerd"
      auto_repair        = true
      auto_upgrade       = true
#      service_account    = "tf-gke-k8s-staging-0njj@xstaging-348615.iam.gserviceaccount.com"
      preemptible        = true
      initial_node_count = 1
    }
  ]

  node_pools_oauth_scopes = {
    all = []

  }

  node_pools_labels = {
    all = {}

    development-node-pool-application = {
      node_group = "application"
    }

    development-node-pool-management = {
      node_group = "management"
    }
  }

  node_pools_metadata = {
    all = {}

  }

  node_pools_taints = {
    all = []

  }

  node_pools_tags = {
    all = []

  }
}
