# IKS and LogDNA Cluster Setup

This module deploys LogDNA and Sysdig agents onto an IKS cluster.

![Deploy LogDNA and Sysdig Agents](../.docs/logdna_sysdig.png)

----

## Table of Contents

1. [Setting Up the Module](##Setting-Up-the-Module)
2. [LogDNA Agent Deployment](##logdna-agent-deployment)
3. [Sysdig Agent Deployment](##Sysdig-Agent-Deployment)
4. [Module Variables](##Module-Variables)

---

## Setting Up the Module

1. [Creating the Docker Images](###Creating-the-Docker-Images)
2. [Cloud Resources](###Cloud-Resources)

### Creating the Docker Images

In order to install LogDNA agents on your cluster you will need acces to the logdna docker image (logdna/logdna-agent:latest). If you do not want your cluster to access the public internet but still communicate with LogDNA, you need to create a copy of the image in [IBM Container Registry](https://cloud.ibm.com/docs/Registry?topic=registry-registry_overview) for your account.

#### Prerequisites

- [Docker](https://www.docker.com/) running on your local machine

#### Creating the LogDNA Agent Image

1. Pull the image from Docker:
```
$ docker pull logdna/logdna-agent:latest
```
2. Tag the pulled image with the region of your IBM Container Registry, your registry namespace, the name for your new repo, and a tag for the new repo. 
```
$ docker tag logdna/logdna-agent:latest <region>.icr.io/<my_namespace>/<image_repo>:<tag>
```
Example:
```
$ docker tag logdna/logdna-agent:latest us.icr.io/asset-development/logdna:latest
```

3. Push your tagged image to the ICR Namespace. Make sure you're target the IBM Cloud region where you want to be able to access your new repository.
```
$ ibmcloud cr login
```
4. Push your image to the IBM Container Registry
```
$ docker push <region>.icr.io/<my_namespace>/<image_repo>:<tag>
```
5. Verify that your image was pushed successfully
```
ibmcloud cr image-list
```

#### Creating the Sysdig Agent Image

Repeat the above steps using the repo `icr.io/ext/sysdig/agent:latest`. While this image is in ICR, it is available through an external endpoint and you may need to create a copy of it to install Sysdig on your cluster.

### Cloud Resources

Make sure you have the following provisioned:
- An [IBM Cloud LogDNA Instance](https://cloud.ibm.com/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-getting-started#getting-started)
- An [IBM Cloud Sysdig Instance](https://cloud.ibm.com/docs/services/Monitoring-with-Sysdig?topic=Sysdig-getting-started#getting-started)

----

## LogDNA Agent Deployment

The LogDNA Agent Deployment creates the following resources:

1. LogDNA Secret
    - Creates a logdna ingestion key in your LogDNA Instance
2. LogDNA Agent Key
    - Creates a kubernetes secret in the default namespace using the LogDNA ingestion key.
3. LogDNA Daemonset
    - This creates a LogDNA agent daemonset in the default namespace based on [this yaml file](https://assets.us-south.logging.cloud.ibm.com/clients/logdna-agent-ds.yaml)

---

## Sysdig Agent Deployment

This deployment procedure is based on the following [IBM bash script](https://ibm.biz/install-sysdig-k8s-agent).

The Sysgig Agent Deployment creates the following resources:

1. IBM Observe Namespace
    - Creates a namespace named `ibm-observe` to deploy the Sysdig Agents.
2. Copy ICR Secrets
    - Copies the ICR image pull secrets from the default namespace.
3. Sysdig Secret
    - Creates a Sysdig Access Key for your Sysdig Instance.
4. Sydig Agent Service Account
    - Creates a service account for the Sysdig Agent in the `ibm-observe` namespace
5. Sysdig Agent Cluster Role
    - Creates a cluster role for the Sysdig Agent Service Account that gives permissions to gather monitoring data about your cluster.
6. Sysdig Agent Cluster Role Binding
    - Binds the new Custer Role to the Sysdig Agent Service Account
7. Sysdig Agent Kubernetes Secret
    - Creates a secret in the `ibm-observe` namespace using the Sysdig Access Key
8. Sysdig Agent Configmap
    - This creates a configmap for the deployment. Due to the limitations of the kubernetes terraform provider, this configmap must be applied using a `kubectl` command.
9. Sysdig Agent Daemonset
    - Applies the following [daemonset](https://raw.githubusercontent.com/draios/sysdig-cloud-scripts/master/agent_deploy/kubernetes/sysdig-agent-daemonset-v2.yaml)

----

## Module Variables

Default variables can be overwritten, any variables without a default must have a value entered in for the module to run.
  
Variable             | Type    | Description                                                               | Default
---------------------|---------|---------------------------------------------------------------------------|--------
`ibmcloud_apikey`    | String  | IBM Cloud IAM API Key                                                     | 
`ibm_region`         | String  | IBM Cloud region where all resources will be deployed                     | `eu-gb`
`resource_group`     | String  | Name of resource group to provision resources                             | `asset-development`
`unique_id`          | String  | Prefix for all resources created in the module. Must begin with a letter. | 
`cluster_name`       | String  | Name of the IKS cluster to deploy your agents                             | 
`cluster_id`         | String  | ID of the IKS cluster to deploy your agents                               |
`logdna_name`        | String  | Name of LogDNA instance                                                   |
`logdna_agent_image` | String  | ICR image for logdna agent                                                | `uk.icr.io/asset-bp2i-test/logdna-agent:latest`
`logdna_endpoint`    | String  | API endpoint prefix for LogDNA (private, public, direct)                  | `private`
`sysdig_name`        | String  | Name of Sysdig Instance                                                   | 
`sysdig_endpoint`    | String  | API endpoint prefix for Sysdig (private, public, direct)                  | `private`
`sysdig_image`       | String  | Image for Sysdig Agent                                                    | `icr.io/ext/sysdig/agent:latest`