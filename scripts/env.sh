# scripts/env.sh

# Resource Group
RG_NAME="myproj-core-rg"

# Locations
LOC_EAST="eastus"
LOC_WEST="westus"

# Admin Username
ADMIN_USERNAME="azureuser"

# VM Names
HOST_NAME="host-vm"
TEST_NAME="test-vm"

# VNet and Subnet Names
VNET_HOST_NAME="myproj-vnet-host"
SUBNET_HOST_NAME="myproj-subnet-host"

VNET_TEST_NAME="myproj-vnet-test"
SUBNET_TEST_NAME="myproj-subnet-test"

# Address Prefixes
VNET_HOST_ADDR="10.20.0.0/16"
SUBNET_HOST_ADDR="10.20.1.0/24"

VNET_TEST_ADDR="10.30.0.0/16"
SUBNET_TEST_ADDR="10.30.1.0/24"

# Bastion Subnet (fixed name required by Azure)
SUBNET_BASTION_NAME="AzureBastionSubnet"
SUBNET_BASTION_ADDR="10.20.254.0/24"

# Peering Names
PEER_TEST_TO_HOST="peer-test-to-host"
PEER_HOST_TO_TEST="peer-host-to-test"
