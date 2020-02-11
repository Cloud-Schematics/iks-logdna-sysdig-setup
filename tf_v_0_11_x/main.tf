##############################################################################
# IBM Cloud Provider
##############################################################################

provider ibm {
  ibmcloud_api_key   = "${var.ibmcloud_apikey}"
  region             = "${var.ibm_region}"
  generation         = 1
  ibmcloud_timeout   = 60
}

##############################################################################


##############################################################################
# Resource Group
##############################################################################

data ibm_resource_group resource_group {
  name = "${var.resource_group}"
}

##############################################################################


##############################################################################
# Get Kube Data
##############################################################################

module kube_setup {
  source = "./kube"
  ibmcloud_api_key  = "${var.ibmcloud_apikey}"
  cluster_name      = "${var.cluster_name}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
}

##############################################################################


##############################################################################
# Kubernetes Provider
##############################################################################

provider kubernetes {

  load_config_file       = false
  host                   = "${module.kube_setup.host}"
  client_certificate     = "${module.kube_setup.client_certificate}"
  client_key             = "${module.kube_setup.client_key}"
  cluster_ca_certificate = "${module.kube_setup.cluster_ca_certificate}"
  
}

##############################################################################