param location string
param environmentCode string
param localResourceGroupName string
param peerings array

// Create one peering resource per entry in the `peerings` array.
resource vnetPeerings 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = [
  for p in peerings: {
    name: '${p.localVnetName}/${p.name}'
    scope: resourceGroup(localResourceGroupName)
    properties: {
      remoteVirtualNetwork: {
        id: p.remoteVirtualNetworkResourceId
      }
      allowVirtualNetworkAccess: p.allowVirtualNetworkAccess
      allowForwardedTraffic: p.allowForwardedTraffic
      allowGatewayTransit: p.allowGatewayTransit
      useRemoteGateways: p.useRemoteGateways
      doNotVerifyRemoteGateways: p.doNotVerifyRemoteGateways
    }
  }
]

output createdPeerings array = [for p in peerings: '${localResourceGroupName}/${p.localVnetName}/${p.name}']
