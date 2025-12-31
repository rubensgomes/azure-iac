# azure-iac

A playground project to demonstrate the use of IaC (e.g. Terraform) and CICD
pipelines (e.g., GitHub Actions Workflow)  to create/destroy several resources
in Azure Cloud.

The steps demonstrated in this project are using a **FRREE** Microsoft Azure
Cloud account.

## Account info

I am using the strategy of having 1 (one) single Subscription owning different
resource groups per environment: dev, qa, stage, and prod.

- account email:       <SECRET_INFO>
- tenant id:           <SECRET_INFO>
- subscription name:   sub-rubens
- subscription id:     <SECRET_INFO>

## Pre-requisites

The following has been previously created in Azure:
- resource group:           rg-rubens-dev

---
Author:  [Rubens Gomes](https://rubensgomes.com/)
