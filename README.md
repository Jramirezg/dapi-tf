# dapi-tf
Terraform to deploy dapi

## Overview

Terraform code to deploy [API for Deloitte challenge](https://github.com/Jramirezg/deloitte-api)

## Requirements

* Terraform version 1.1.5 or higher
* Azure Account with the required privileges (Owner or Contributor on the subscription)
* Access to the Docker image of dapi

## Assumptions

* The solution was built trying to minimize the amount of time invested and the cost of running it.
* A subscription is already created in Azure. No subscription creation was done
* No extra requirements were implemented (logging, security, etc)
* Let's encrypt was used and an Azure domain was used as well. No extra components were deployed (cost was kept in mind)


## Out of scope

* Kubernetes deployment: It would be nice to deploy a Kubernetes cluster with an ingress controller handling the traffic. This was not done, since it would make running the solution more expensive and a single container instance will work as well for this test.
* A helm chart for the solution was built in (Helm dapi)[https://github.com/Jramirezg/deloitte-api-helm]. It was used for internal deployment in my homelab K3S cluster.

## Architecture

The code implements:

* A resource group to deploy all elements in
* A storage account to preserve the Let's Encrypt certrificate once obtained
* A storage share to mount to the caddy pod (reverse proxy).
* A container group with two containers: A container with the dapi application and another one with the caddy reverse proxy to implement SSL termination.

## Run instructions

Fill the variables subscription_id, tenant_id and client_id. The variable secret will be requested at runtime.

Note: It is also possible to provide this config as environment variables.

Execute the following to review the deployment plan:

```bash
terraform plan --var-file=env/test.tfvars
```

Execute the following to apply the reviewed deployement plan:

```bash
terraform apply --var-file=env/test.tfvars
```

## Testing

```bash
curl --location --request POST 'https://dapisvc.westeurope.azurecontainer.io/string' \
--header 'Content-Type: text/plain' \
--data-raw '"We really like the new security features of Google Cloud and Amazon "'
```