##############################################################################`
# Gets cluster config and downloads it to .kube/config
# Waits for cluster name before starting
##############################################################################`

data ibm_container_cluster_config cluster {
  
  cluster_name_id   = "${var.cluster_name}"
  config_dir        = "kube/config"
  admin             = true
  resource_group_id = "${var.resource_group_id}"

}

##############################################################################`


##############################################################################`
#
##############################################################################`

data external kube_config {
  program = [
    "bash",                                  # Run with bash
    "${path.module}/config/kube_config.sh",  # Script to run
    "${var.ibmcloud_api_key}",               # IBM Cloud API Key
    "${var.cluster_name}",                   # Cluster name
    "${var.resource_group_id}"               # Resource group ID
  ]
}


##############################################################################`


##############################################################################`
# Kube config data
##############################################################################`

data null_data_source kube_config {
  
  inputs = {
    cluster_id             = "${data.ibm_container_cluster_config.cluster.id}"
    host                   = "${data.external.kube_config.result["host"]}"      
    client_certificate     = "${data.external.kube_config.result["admin"]}"     
    client_key             = "${data.external.kube_config.result["admin_key"]}" 
    cluster_ca_certificate = "${data.external.kube_config.result["ca_cert"]}"   
    config_path            = "${data.ibm_container_cluster_config.cluster.config_file_path}"
    cluster_name           = "${var.cluster_name}"
  }

}

##############################################################################
