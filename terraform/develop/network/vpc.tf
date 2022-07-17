module "vpc" {
    source = "terraform-google-modules/network/google"
    version      = "5.0.0"
    project_id   = "topgun-servian"
    network_name = "dev-vpc"

    subnets = [
        {
            subnet_name           = "dev-subnet-01"
            subnet_ip             = "10.88.128.0/17"
            subnet_region         = "us-east1"
        },
    ]

     secondary_ranges = {
        dev-subnet-01 = [     
            {
                range_name    = "dev-subnet-01-pods-secondary"
                ip_cidr_range = "10.128.0.0/16"
            },

            {
                range_name    = "dev-subnet-01-service-secondary"
                ip_cidr_range = "10.129.0.0/16"
            }
        ]
    }
}
