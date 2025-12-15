# Development Environment
location = "eastus"
prefix   = "dev"
admin_ip_ranges = [
  "203.0.113.0/24", # Example: Office IP range
  "198.51.100.0/24" # Example: VPN IP range
]

tags = {
  environment = "development"
  managed_by  = "terraform"
  project     = "containers"
  cost_center = "it-infrastructure"
}
