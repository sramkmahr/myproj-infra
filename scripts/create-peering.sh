#!/bin/bash

# ✅ Load variables
source "$(dirname "$0")/env.sh"

# ✅ Dynamically fetch subscription ID (safer than hardcoding)
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

echo "🔗 Starting VNet Peering..."

# ✅ Peering: Test → Host
echo "➡️ Checking $PEER_TEST_TO_HOST..."
if az network vnet peering show --resource-group "$RG_NAME" --vnet-name "$VNET_TEST_NAME" --name "$PEER_TEST_TO_HOST" &>/dev/null; then
  echo "✅ $PEER_TEST_TO_HOST already exists. Skipping."
else
  echo "🚀 Creating $PEER_TEST_TO_HOST..."
  az network vnet peering create \
    --resource-group "$RG_NAME" \
    --vnet-name "$VNET_TEST_NAME" \
    --name "$PEER_TEST_TO_HOST" \
    --remote-vnet "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG_NAME/providers/Microsoft.Network/virtualNetworks/$VNET_HOST_NAME" \
    --allow-vnet-access
fi

# ✅ Peering: Host → Test
echo "➡️ Checking $PEER_HOST_TO_TEST..."
if az network vnet peering show --resource-group "$RG_NAME" --vnet-name "$VNET_HOST_NAME" --name "$PEER_HOST_TO_TEST" &>/dev/null; then
  echo "✅ $PEER_HOST_TO_TEST already exists. Skipping."
else
  echo "🚀 Creating $PEER_HOST_TO_TEST..."
  az network vnet peering create \
    --resource-group "$RG_NAME" \
    --vnet-name "$VNET_HOST_NAME" \
    --name "$PEER_HOST_TO_TEST" \
    --remote-vnet "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RG_NAME/providers/Microsoft.Network/virtualNetworks/$VNET_TEST_NAME" \
    --allow-vnet-access
fi

echo "✅ All peering connections complete."
