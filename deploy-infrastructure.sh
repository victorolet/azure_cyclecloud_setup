#!/bin/bash

# Set variables
RESOURCE_GROUP="cycle-cloud-prod"
LOCATION="eastus"
VNET_NAME="cc-demo"
STORAGE_ACCOUNT_NAME="ccdemo$(date +%s)"  # Adding timestamp to ensure uniqueness
BASTION_NAME="cc-bastion"

BASTION_IP_NAME="cc-demo-bastion"
VNET_ADDRESS_PREFIX="10.0.0.0/16"
SUBNET_ADDRESS_PREFIX="10.0.1.0/24"
BASTION_SUBNET_PREFIX="10.0.2.0/24"

# Get current user's object ID
CURRENT_USER_ID=$(az ad signed-in-user show --query id -o tsv)

# Create Resource Group
az group create \
    --name $RESOURCE_GROUP \
    --location $LOCATION

# Assign Contributor role to the Resource Group
az role assignment create \
    --role "Contributor" \
    --assignee-object-id $CURRENT_USER_ID \
    --assignee-principal-type User \
    --scope "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP"

# Create Virtual Network with default subnet
az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name $VNET_NAME \
    --address-prefix $VNET_ADDRESS_PREFIX \
    --subnet-name "default" \
    --subnet-prefix $SUBNET_ADDRESS_PREFIX

# Create Bastion subnet (required for Azure Bastion)
az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $VNET_NAME \
    --name "AzureBastionSubnet" \
    --address-prefix $BASTION_SUBNET_PREFIX

# Create Storage Account
az storage account create \
    --resource-group $RESOURCE_GROUP \
    --name $STORAGE_ACCOUNT_NAME \
    --location $LOCATION \
    --sku Standard_LRS \
    --kind StorageV2 \
    --https-only true

# Create Public IP for Bastion
az network public-ip create \
    --resource-group $RESOURCE_GROUP \
    --name $BASTION_IP_NAME \
    --sku Standard \
    --location $LOCATION

# Create Bastion Host
az network bastion create \
    --resource-group $RESOURCE_GROUP \
    --name $BASTION_NAME \
    --public-ip-address $BASTION_IP_NAME \
    --vnet-name $VNET_NAME \
    --location $LOCATION

# Output important information
echo "Infrastructure deployment completed!"
echo "Resource Group: $RESOURCE_GROUP"
echo "Virtual Network: $VNET_NAME"
echo "Storage Account: $STORAGE_ACCOUNT_NAME"
echo "Bastion Host: $BASTION_NAME"

# To create a new app registration:
#az ad app create --display-name "YourAppName" --identifier-uris "api://yourappname"

# To create a service principal for that application (which you'll need to assign roles):
# az ad sp create --id [application-id-from-previous-step]

# Create a client secret for the application:
#az ad app credential reset --id [application-id-from-previous-step] --append

#To assign a role to your managed identity for CycleCloud, you can use:
#az role assignment create --assignee "[your-managed-identity-client-id]" --role "Contributor" --scope "/subscriptions/260c6c16-dad8-477f-b894-133e44827516"

az ad app create --display-name "CCApp" --identifier-uris "api://ccapp"
az ad sp create --id 55ed6109-4636-403d-bece-65c4ed51131a
az ad app credential reset --id 55ed6109-4636-403d-bece-65c4ed51131a --append
az role assignment create --assignee "55ed6109-4636-403d-bece-65c4ed51131a" --role "Contributor" --scope "/subscriptions/260c6c16-dad8-477f-b894-133e44827516"