# azure-iac

A playground project to demonstrate the use of IaC (e.g. Terraform) and CICD
pipelines (e.g., GitHub Actions Workflow)  to create/destroy several
infrastructure resources (e.g., resource group, storage account, networking, app
configuration, container registry, container app, and database) in Azure Cloud.

## Account Info

I am using the infrastructure configuration strategy of having 1 (one) single
Azure Subscription owning different resource groups per environment: dev, qa,
stage, and prod.

- account email:       <SECRET_INFO>
- tenant id:           <SECRET_INFO>
- subscription name:   sub-rubens
- subscription id:     <SECRET_INFO>

## Pre-requisites

The following pre-requisites must be met:

- Microsoft Azure account
- GitHub account
- Local Ubuntu Linux
- Azure CLI 2.81
- Terraform 1.14.x

## Application and Infra-structure Requirements

Microservice application requirements:

- Java 25
- Spring Boot 4.0.x
- Spring Cloud Azure SDK 7.x.x
- PostgreSQL 18.x

Azure infrastructure requirements:

- Azure App Configuration to store some configurations
- Azure KeyVault to store secret (e.g., password) configurations
- Azure Container Registry (ACR) to store dockerized images
- Azure App Container (ACA) environment to deploy containerized application
- Azure PostgreSQL internal private database
- Azure Web Application Firewall (WAF) to block malicious requests
- Microservice REST API end-points publicly reachable (e.g., browsers)

## Infrastructure Configuration Phases

The authentication of Terraform against Azure is based on using a `Service
Principal + Secrets`. And the Terraform infrastructure code has been broken into
the following phases:

### Phase 0 (bootstrap-backend):

This steps is done only once. It creates the following base resources
required by Terraform:

 - Resource group (e.g., "rg-tfstate")
 - Storage account (e.g., "sttfstaterubens01")
 - Blob Container (e.g., "tfstate")

---
Author:  [Rubens Gomes](https://rubensgomes.com/)
