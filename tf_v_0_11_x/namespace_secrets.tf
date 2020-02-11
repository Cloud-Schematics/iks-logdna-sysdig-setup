##############################################################################
# Local Variables for Namespace Secrets
##############################################################################

locals {
  image_pull_secrets =[
    "jp-icr-io", 
    "au-icr-io", 
    "de-icr-io", 
    "uk-icr-io",
    "us-icr-io",
    "icr-io"
  ]
}

##############################################################################


##############################################################################
# Create Namespace
# - Awaits LogDNA deployment
##############################################################################

resource kubernetes_namespace ibm_observe {
  metadata {
    name = "ibm-observe"
  }

  depends_on = ["kubernetes_daemonset.logdna_agent"]
}
##############################################################################


##############################################################################
# Default pull secret
##############################################################################

data kubernetes_secret image_pull_secret {

  count = "${length(local.image_pull_secrets)}"  

  metadata {
    name = "default-${element(local.image_pull_secrets, count.index)}"
  }

}

##############################################################################


##############################################################################
# Copy image pull secret to ibm-observe
##############################################################################

resource kubernetes_secret copy_image_pull_secret {

  count = "${length(local.image_pull_secrets)}"

  metadata {
    name      = "ibm-observe-${element(local.image_pull_secrets, count.index)}"
    namespace = "${kubernetes_namespace.ibm_observe.metadata.0.name}"
  }
  
  data      = {
    ".dockerconfigjson" = "${element(data.kubernetes_secret.image_pull_secret.*.data..dockerconfigjson, count.index)}"
  }

  type = "kubernetes.io/dockerconfigjson"

}

##############################################################################