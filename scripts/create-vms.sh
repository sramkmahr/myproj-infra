#!/bin/bash

# ⛑️ Exit on error, undefined var, or pipefail
set -euo pipefail

# ✅ Load environment variables
source "$(dirname "$0")/env.sh"

# ✅ Get public SSH key from Key Vault (for Linux VMs)
SSH_PUBLIC_KEY=$(az keyvault secret show \
  --vault-name myprojkv1234567890 \
  --name vm-ssh-public-key \
  --query value -o tsv)

# ✅ Function to create a Linux VM
create_linux_vm() {
  local vm_name=$1
  local vnet_name=$2
  local subnet_name=$3
  local location=$4

  echo "➡️ Checking if $vm_name exists..."
  if az vm show --resource-group "$RG_NAME" --name "$vm_name" &>/dev/null; then
    echo "✅ $vm_name already exists. Skipping."
  else
    echo "🚀 Creating Linux VM: $vm_name..."
    az vm create \
      --resource-group "$RG_NAME" \
      --name "$vm_name" \
      --image Ubuntu2204 \
      --admin-username "$ADMIN_USERNAME" \
      --size Standard_B1s \
      --authentication-type ssh \
      --ssh-key-value "$SSH_PUBLIC_KEY" \
      --vnet-name "$vnet_name" \
      --subnet "$subnet_name" \
      --public-ip-address "" \
      --location "$location"
  fi
  echo
}

# ✅ Create VMs (no public IPs)

# 1️⃣ Host VM (Linux)
create_linux_vm "$HOST_NAME" "$VNET_HOST_NAME" "$SUBNET_HOST_NAME" "$LOC_EAST"

# 2️⃣ Test VM (Linux)
create_linux_vm "$TEST_NAME" "$VNET_TEST_NAME" "$SUBNET_TEST_NAME" "$LOC_WEST"

echo "✅ All VMs created successfully."
