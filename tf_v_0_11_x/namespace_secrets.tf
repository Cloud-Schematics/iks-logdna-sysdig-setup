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

  count = "${length(var.image_pull_secrets)}"  

  metadata {
    name = "default-${element(var.image_pull_secrets, count.index)}"
  }

}

##############################################################################


##############################################################################
# Copy image pull secret to ibm-observe
##############################################################################

resource kubernetes_secret copy_image_pull_secret {

  count = "${length(var.image_pull_secrets)}"

  metadata {
    name      = "ibm-observe-${element(var.image_pull_secrets, count.index)}"
    namespace = "${kubernetes_namespace.ibm_observe.metadata.0.name}"
  }
  
  data      = {
    ".dockerconfigjson" = "${element(data.kubernetes_secret.image_pull_secret.*.data..dockerconfigjson, count.index)}"
  }

  type = "kubernetes.io/dockerconfigjson"

}

##############################################################################