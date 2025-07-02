#!/bin/bash

set -euo pipefail

# Load environment
source "$(dirname "$0")/env.sh"

# Bastion config
BASTION_NAME="myproj-bastion"
BASTION_IP_NAME="myproj-bastion-ip"

echo "🛡️ Creating Azure Bastion host..."

# Check if Bastion subnet exists (Azure requires exact name: AzureBastionSubnet)
if ! az network vnet subnet show --name "$SUBNET_BASTION_NAME" --vnet-name "$VNET_HOST_NAME" --resource-group "$RG_NAME" &>/dev/null; then
  echo "📦 Creating Bastion subnet ($SUBNET_BASTION_NAME)..."
  az network vnet subnet create \
    --name "$SUBNET_BASTION_NAME" \
    --vnet-name "$VNET_HOST_NAME" \
    --resource-group "$RG_NAME" \
    --address-prefixes "$SUBNET_BASTION_ADDR"
fi

# Check if Bastion already exists
if az network bastion show --name "$BASTION_NAME" --resource-group "$RG_NAME" &>/dev/null; then
  echo "✅ Bastion host $BASTION_NAME already exists. Skipping."
else
  echo "🌐 Creating public IP for Bastion..."
  az network public-ip create \
    --resource-group "$RG_NAME" \
    --name "$BASTION_IP_NAME" \
    --sku Standard \
    --location "$LOC_EAST" \
    --allocation-method Static

  echo "🚀 Creating Bastion host..."
  az network bastion create \
    --name "$BASTION_NAME" \
    --resource-group "$RG_NAME" \
    --location "$LOC_EAST" \
    --vnet-name "$VNET_HOST_NAME" \
    --public-ip-address "$BASTION_IP_NAME" \
    --sku Standard \
    --enable-tunneling true

  echo "✅ Bastion host created successfully."
fi
