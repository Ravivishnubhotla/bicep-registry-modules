# Virtual Network Peering - NonProd-001

This directory contains consolidated Bicep and parameter files for deploying all virtual network peerings in the NonProd-001 environment.

## Overview

The virtual network peering configuration establishes connectivity between multiple virtual networks across different subscriptions:
- **Hub VNet** (Production subscription) - Central gateway and services
- **Core VNet** (NonProd subscription) - Core shared services
- **Management VNet** (NonProd subscription) - Management and monitoring
- **User VNet** (NonProd subscription) - User workloads
- **Shared VNet** (Prod subscription) - Shared services
- **Shared-Ext VNet** (Prod subscription) - External access points

## Files

### vnetpeering.bicep
Main Bicep template that deploys multiple virtual network peerings using a loop. It accepts:
- `remoteVirtualNetworks` - Object mapping friendly names to full resource IDs
- `peerings` - Array of peering configurations
- `enableTelemetry` - Boolean to enable AVM telemetry (default: true)

**Key Features:**
- Uses AVM (Azure Verified Modules) for vnet peering deployments
- Flexible parameter structure supporting both direct and named remote VNet references
- Returns arrays of deployed peering names and resource IDs

### vnetpeering.parameters.json
Parameter file containing all 15 peering configurations organized by:
- **remoteVirtualNetworks** - Centralized definitions of all remote VNets
- **peerings** - Array of all peering relationships

## Remote Virtual Networks

| Name | Purpose | Subscription | Resource Group |
|------|---------|--------------|-----------------|
| **gw** | Hub Gateway VNet | Production | smvllc-use2-hub-rgrp01 |
| **core** | NonProd Core Services | NonProd | smvllc-use2-nonprod-spoke-rgrp-001 |
| **mgmt** | Management & Monitoring | NonProd | smvllc-use2-nonprod-spoke-rgrp-001 |
| **user** | User Workloads | NonProd | smvllc-use2-nonprod-spoke-rgrp-001 |
| **shared** | Production Shared Services | Prod | smvllc-use2-prod-spoke-rgrp-001 |
| **sharedExt** | External Access Points | Prod | smvllc-use2-prod-spoke-rgrp-001 |

## Peering Configurations

All peerings use the following default settings:
- ✅ **Allow Virtual Network Access** - Enabled
- ✅ **Allow Forwarded Traffic** - Enabled
- ❌ **Allow Gateway Transit** - Disabled
- ✅ **Do Not Verify Remote Gateways** - Enabled
- ❌ **Use Remote Gateways** - Disabled

### Peering Matrix

| Local VNet | Remote VNet | Purpose |
|------------|-------------|---------|
| **Core** | Gateway (Hub) | Central routing and VPN termination |
| **Core** | Management | Cross-tier management connectivity |
| **Core** | User | Core-to-workload connectivity ||
| **Management** | Core | Bidirectional management visibility ||
| **Management** | User | Cross-tier management connectivity |
| **User** | Core | Workload-to-core connectivity |
| **User** | Management | Workload access to management plane |

## Deployment

### Prerequisites
- Azure CLI configured with appropriate subscription context
- Contributor role on the target resource groups
- AVM module dependencies available (referenced from MCR)

### Deploy All Peerings
Deploy all 15 peering configurations in a single operation:

```bash
az deployment group create \
  --name smvllc-lz-vnet-peering-all \
  --resource-group smvllc-use2-nonprod-spoke-rgrp-001 \
  --template-file vnetpeering.bicep \
  --parameters @vnetpeering.parameters.json
```

### Outputs
The deployment returns:
- `peeringNames` - Array of all deployed peering resource names
- `peeringResourceIds` - Array of all deployed peering resource IDs

## Modifying Peerings

### Add a New Peering
1. If the remote VNet doesn't exist in `remoteVirtualNetworks`, add it:
   ```json
   "newVnetName": "/subscriptions/{subId}/resourceGroups/{rgName}/providers/Microsoft.Network/virtualNetworks/{vnetName}"
   ```

2. Add a peering entry to the `peerings` array:
   ```json
   {
     "name": "local-vnet_remote-vnetName_peering",
     "localVnetName": "smvllc-use2-nonprod-vnet-local",
     "remoteVnetName": "newVnetName",
     "allowForwardedTraffic": true,
     "allowGatewayTransit": false,
     "allowVirtualNetworkAccess": true,
     "doNotVerifyRemoteGateways": true,
     "useRemoteGateways": false
   }
   ```

### Update Remote VNet Reference
Simply modify the resource ID in the `remoteVirtualNetworks` section. All peerings referencing that VNet by name will automatically use the updated value.

## Troubleshooting

### Peering Fails to Deploy
- Verify the local VNet exists in the resource group
- Verify the remote VNet resource ID is correct
- Ensure proper RBAC permissions on both VNets
- Check that both subscriptions are accessible

### Cross-Subscription Peering Issues
- Verify the service principal has permissions in both subscriptions
- Ensure the remote VNet resource ID includes the correct subscription ID
- Review Azure activity logs for specific error messages

## Related Documentation

- [Azure Virtual Network Peering](https://docs.microsoft.com/azure/virtual-network/virtual-network-peering-overview)
- [Azure Verified Modules - Virtual Network](https://azure.github.io/Azure-Verified-Modules/indexes/bicep/bicep-resource-modules/)
- [SMVLLC Networking Architecture](../../README.md)