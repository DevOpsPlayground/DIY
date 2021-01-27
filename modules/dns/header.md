# DPG - dns module

This requires a hosted zone so for the average use will not be used.

example jenkins DNS module

``` HCL
module "dns_jenkins" {
  count        = var.deploy_count
  depends_on   = [module.jenkins]
  source       = "./../../modules/dns"
  instances    = var.instances
  instance_ips = element(module.jenkins.*.public_ips, count.index)
  record_name  = happy-panda"
}
```
