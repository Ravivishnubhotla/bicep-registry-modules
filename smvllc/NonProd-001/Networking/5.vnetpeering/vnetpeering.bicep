@description('Object containing remote virtual network resource IDs by name')
param remoteVirtualNetworks object = {}

@description('Array of virtual network peering configurations')
param peerings array

@description('Location for the deployment metadata (not used by peering resources)')
param location string = resourceGroup().location

@description('Enable telemetry for AVM modules')
param enableTelemetry bool = true

// Deploy each peering configuration
module vnetPeering '../../../../../avm/res/network/virtual-network/virtual-network-peering/main.bicep' = [
  for peering in peerings: {
    name: 'peering-${peering.name}'
    params: {
      name: peering.name
      localVnetName: peering.localVnetName
      remoteVirtualNetworkResourceId: contains(peering, 'remoteVirtualNetworkResourceId')
        ? peering.remoteVirtualNetworkResourceId
        : remoteVirtualNetworks[peering.remoteVnetName]
      allowForwardedTraffic: peering.allowForwardedTraffic
      allowGatewayTransit: peering.allowGatewayTransit
      allowVirtualNetworkAccess: peering.allowVirtualNetworkAccess
      doNotVerifyRemoteGateways: peering.doNotVerifyRemoteGateways
      useRemoteGateways: peering.useRemoteGateways
      enableTelemetry: enableTelemetry
    }
  }
]

@description('Array of deployed peering names')
output peeringNames array = [for (peering, i) in peerings: vnetPeering[i].outputs.name]

@description('Array of deployed peering resource IDs')
output peeringResourceIds array = [for (peering, i) in peerings: vnetPeering[i].outputs.resourceId]
