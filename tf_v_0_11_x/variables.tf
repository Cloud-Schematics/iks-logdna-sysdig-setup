##############################################################################
# Account Variables
##############################################################################

variable resource_group {
  description = "Name of resource group to provision resources"
  default     = "asset-development"
}

variable ibmcloud_apikey {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
}

variable ibm_region {
  description = "IBM Cloud region where all resources will be deployed"
  default     = "eu-gb"
}

variable unique_id {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
}

##############################################################################


##############################################################################
# Cluster Variables
##############################################################################

variable cluster_name {
  description = "name for the iks cluster"
}

variable cluster_id {
  description = "id of iks cluster"
}

##############################################################################


##############################################################################
# LogDNA Variables
##############################################################################

variable logdna_name {
  description = "Name of LogDNA instance"
}

variable logdna_agent_image {
  description = "ICR image for logdna agent"
  default     = "uk.icr.io/asset-bp2i-test/logdna-agent:latest"
}

variable logdna_endpoint {
  description = "API endpoint prefix for LogDNA (private, public, direct)"
  default     = "private"
}


##############################################################################


##############################################################################
# Sysdig Variables
##############################################################################

variable sysdig_name {
  description = "Name of Sysdig instance"
}

variable sysdig_endpoint {
  description = "API endpoint prefix for Sysdig (private, public, direct)"
  default     = "private" 
}

variable sysdig_image {
  description = "Image for Sysdig Agent"
  default     = "icr.io/ext/sysdig/agent:latest"
}

##############################################################################


##############################################################################
# Image pull secrets
##############################################################################

variable image_pull_secrets {
  description = "Image pull secrets to copy to ibm-observe namespace"
  default     = [
    "jp-icr-io", 
    "au-icr-io", 
    "de-icr-io", 
    "uk-icr-io",
    "us-icr-io",
    "icr-io"
  ]
}


##############################################################################