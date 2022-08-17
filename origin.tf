resource "volterra_origin_pool" "pg-auto-pool" {
  name                   = "${var.projectPrefix}-pool"
  namespace              = var.namespace
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = 80
  no_tls                 = true 
  
  dynamic "origin_servers" {
    for_each = aws_instance.vpc1-vms.*.public_ip
    content {
      public_ip {
        ip = origin_servers.value
      }
      labels = {
        "server" = "${origin_servers.key+1}"
      }
    }
  }
  #advanced_options {
  #  enable_subsets {
  #   endpoint_subsets {
  #      keys = ["server"]
  #   }
  #  }
  #}
}