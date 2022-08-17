resource "volterra_http_loadbalancer" "pg-auto-lb" {
  name                            =  "${var.projectPrefix}"
  namespace                       = var.namespace
  description                     = "HTTPS loadbalancer object ${var.projectPrefix} test"
  #use this to select specific subdomains
  #domains                         = ["school-1.${var.domain}", "school-2.${var.domain}","school-3.${var.domain}","school-4.${var.domain}","school-5.${var.domain}","school-6.${var.domain}","school-7.${var.domain}","school-8.${var.domain}","school-9.${var.domain}","school-10.${var.domain}","school-11.${var.domain}","school-12.${var.domain}","school-13.${var.domain}","school-14.${var.domain}","school-15.${var.domain}","school-16.${var.domain}"]
  
  #use this to match all subdoains and route using host headers (limit 256 routes)
  domains                         = [ "*.${var.domain}" ]
  advertise_on_public_default_vip = true
  no_service_policies             = true
  disable_rate_limit              = true
  round_robin                     = true
  service_policies_from_namespace = true
  no_challenge                    = true


dynamic "routes" {
    for_each = aws_instance.vpc1-vms.*.public_ip
    content {
    simple_route {
      path {
        prefix = "/"
      }
      http_method = "ANY"
      origin_pools  {
       pool  {
        name      = volterra_origin_pool.pg-auto-pool.name
        namespace = var.namespace
       }
       weight = 1
       priority = 1
       endpoint_subsets = {
        server = "${routes.key+1}"
       }
      }
      headers {
       name = "host"
       exact = "school-${routes.key+1}.${var.domain}"
       invert_match = false
      }
    }
   } 
  }

 
  https_auto_cert {
    add_hsts      = false
    http_redirect = false
    no_mtls       = true
  }
}