# LogDNA Sysdig Setup for IKS on VPC

Creates LogDNA and Sysdig deployments for an IKS Cluster

## Creates

- LogDNA Agent Deployment
    - LogDNA secret for a resource instance
    - kubernetes secret for LogDNA agent
    - Daemonset for logdna agent depoloyment
- Sysdig Agent Deployment
    - ibm-observe namespace for sysdig agent deployments
    - ICR image pull secret copies for ibm-observe namespace
    - Sysdig secret for a resource instance
    - Sysdig agent service account for ibm-observe
    - Cluster role for sysdig agent service account
    - Cluster role binding for sysdig agent
    - Kubernetes secret for sysdig agent in ibm-observe using sysdig secret
    - Configmap for sysdig agents *(due to Kubernetes provider limitations this is created using a kubectl command)*
    - Daemonset for sysdig agent deployment

## Scripts

### Null Resources

- `configure_monitoring`
    - Uses a yaml file and a kubectl command to apply a configmap for sysdig to the ibm-observe namespace