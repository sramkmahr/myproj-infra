#!/bin/bash

# ✅ Load variables from env.sh
source "$(dirname "$0")/env.sh"

echo "🔧 Starting VNet creation process..."

# ---------- Host VNet ----------
echo "➡️ Checking if Host VNet already exists..."

if az network vnet show --resource-group "$RG_NAME" --name "$VNET_HOST_NAME" &>/dev/null; then
  echo "✅ $VNET_HOST_NAME already exists. Skipping."
else
  echo "🚀 Creating $VNET_HOST_NAME..."
  az network vnet create \
    --resource-group "$RG_NAME" \
    --name "$VNET_HOST_NAME" \
    --address-prefix "$VNET_HOST_ADDR" \
    --subnet-name "$SUBNET_HOST_NAME" \
    --subnet-prefix "$SUBNET_HOST_ADDR" \
    --location "$LOC_EAST"
fi

# ---------- Bastion Subnet in Host VNet ----------
echo "➡️ Creating Azure Bastion subnet in $VNET_HOST_NAME..."

if az network vnet subnet show \
  --resource-group "$RG_NAME" \
  --vnet-name "$VNET_HOST_NAME" \
  --name AzureBastionSubnet &>/dev/null; then
  echo "✅ AzureBastionSubnet already exists. Skipping."
else
  echo "🚀 Creating AzureBastionSubnet..."
  az network vnet subnet create \
    --resource-group "$RG_NAME" \
    --vnet-name "$VNET_HOST_NAME" \
    --name AzureBastionSubnet \
    --address-prefixes "$SUBNET_BASTION_ADDR"
fi

# ---------- Test VNet ----------
echo "➡️ Checking if Test VNet already exists..."

if az network vnet show --resource-group "$RG_NAME" --name "$VNET_TEST_NAME" &>/dev/null; then
  echo "✅ $VNET_TEST_NAME already exists. Skipping."
else
  echo "🚀 Creating $VNET_TEST_NAME..."
  az network vnet create \
    --resource-group "$RG_NAME" \
    --name "$VNET_TEST_NAME" \
    --address-prefix "$VNET_TEST_ADDR" \
    --subnet-name "$SUBNET_TEST_NAME" \
    --subnet-prefix "$SUBNET_TEST_ADDR" \
    --location "$LOC_WEST"
fi

echo "✅ All VNets and subnets created successfully!"
