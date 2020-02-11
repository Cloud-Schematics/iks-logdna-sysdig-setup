##############################################################################
# Kube Cert Outputs
##############################################################################

output host {
  value     = "${data.null_data_source.kube_config.outputs["host"]}"
  sensitive = true
}

output client_certificate {
  value     = "${data.null_data_source.kube_config.outputs["client_certificate"]}"
  sensitive = true
}

output client_key {
  value     = "${data.null_data_source.kube_config.outputs["client_key"]}"
  sensitive = true
}

output cluster_ca_certificate {
  value     = "${data.null_data_source.kube_config.outputs["cluster_ca_certificate"]}"  
  sensitive = true
}

##############################################################################


##############################################################################
# Kube CONFIG Outputs
##############################################################################

output "cluster_id" {
  value     = "${data.null_data_source.kube_config.outputs["cluster_id"]}"
  sensitive = true
}


output config_path {
  value     = "${data.null_data_source.kube_config.outputs["config_path"]}"  
  sensitive = true
}


output cluster_name {
  value     = "${data.null_data_source.kube_config.outputs["cluster_name"]}"  
  sensitive = true
}


##############################################################################