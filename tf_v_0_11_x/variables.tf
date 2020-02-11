##############################################################################
# Account Variables
##############################################################################

variable ibmcloud_apikey {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
}

variable resource_group {
  description = "Name of resource group to provision resources"
  default     = "default"
}

variable ibm_region {
  description = "IBM Cloud region where all resources will be deployed"
  default     = "us-south"
}

variable unique_id {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  default     = "log-mon-setup"
}

##############################################################################


##############################################################################
# Cluster Variables
##############################################################################

variable cluster_name {
  description = "Name for the iks cluster to deploy agents"
}

variable cluster_id {
  description = "ID of iks cluster to deploy agents"
}

##############################################################################


##############################################################################
# LogDNA Variables
##############################################################################

variable logdna_name {
  description = "Name of LogDNA instance"
}

variable logdna_agent_image {
  description = "Image for logdna agent"
  default     = "logdna/logdna-agent:latest"
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