#!/bin/bash

# Load environment
source "$(dirname "$0")/env.sh"

# Get subscription ID
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

# DNS zone name
DNS_ZONE_NAME="priv.myproj.local"

echo "🔧 Creating private DNS zone..."

# Step 1: Create DNS zone (if not exists)
if az network private-dns zone show --resource-group "$RG_NAME" --name "$DNS_ZONE_NAME" &>/dev/null; then
  echo "✅ DNS zone $DNS_ZONE_NAME already exists. Skipping."
else
  az network private-dns zone create \
    --resource-group "$RG_NAME" \
    --name "$DNS_ZONE_NAME"
  echo "✅ DNS zone created."
fi

# Function to link VNet
link_vnet_to_dns() {
  local vnet_name=$1
  local link_name=$2
  local registration=$3

  echo "🔗 Linking VNet $vnet_name to DNS zone..."

  az network private-dns link vnet create \
    --resource-group "$RG_NAME" \
    --zone-name "$DNS_ZONE_NAME" \
    --name "$link_name" \
    --virtual-network "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG_NAME/providers/Microsoft.Network/virtualNetworks/$vnet_name" \
    --registration-enabled "$registration"
}

# Step 2: Link active VNets only
link_vnet_to_dns "$VNET_TEST_NAME"  "link-test"  true
link_vnet_to_dns "$VNET_HOST_NAME"  "link-host"  true

echo "✅ Private DNS zone setup complete."
