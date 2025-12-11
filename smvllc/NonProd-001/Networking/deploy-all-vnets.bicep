metadata name = 'Prod-001 Deploy All VNets'
metadata description = 'Deploys all Virtual Networks for Prod-001 environment (core, mgmt, user).'

@description('Required. Naming prefix for all resources.')
param namePrefix string

@description('Optional. Environment/location code (e.g., use2 for US East 2).')
param environmentCode string = 'use2'

@description('Optional. Environment type (e.g., nonprod, prod).')
param environmentType string = 'prod'

@description('Optional. Azure location for all resources.')
param location string = resourceGroup().location

@description('Tags for all resources.')
param tags object = {
  Domain: 'Infrastructure'
  DomainOwner: 'ravi.vishnubhotla2@gmail.com'
  LifeCycle: 'Prod'
}

// Naming convention
var namingConvention = '${namePrefix}-${environmentCode}-${environmentType}'

// VNet names and address prefixes
var vnetConfigs = {
  core: {
    name: '${namingConvention}-vnet-core-001'
    addressPrefixes: ['10.251.0.0/18']
  }
  mgmt: {
    name: '${namingConvention}-vnet-mgmt-001'
    addressPrefixes: ['10.251.72.0/22', '10.251.80.0/24']
  }
  user: {
    name: '${namingConvention}-vnet-user-001'
    addressPrefixes: ['10.251.128.0/18']
  }
}

// ============================================================================
// Virtual Network modules (AVM)
// Note: Subnets and peerings should ideally be passed into the VNet module as
// child resources. For now these modules deploy VNets and return resource ids
// and names. Add subnets/peerings later if desired.
// ============================================================================

module vnetCore 'br/public:avm/res/network/virtual-network:0.7.2' = {
  name: 'vnet-core'
  params: {
    name: vnetConfigs.core.name
    location: location
    tags: tags
    addressPrefixes: vnetConfigs.core.addressPrefixes
  }
}

module vnetMgmt 'br/public:avm/res/network/virtual-network:0.7.2' = {
  name: 'vnet-mgmt'
  params: {
    name: vnetConfigs.mgmt.name
    location: location
    tags: tags
    addressPrefixes: vnetConfigs.mgmt.addressPrefixes
  }
}

module vnetUser 'br/public:avm/res/network/virtual-network:0.7.2' = {
  name: 'vnet-user'
  params: {
    name: vnetConfigs.user.name
    location: location
    tags: tags
    addressPrefixes: vnetConfigs.user.addressPrefixes
  }
}

// ============================================================================
// OUTPUTS
// ============================================================================

output deployedVirtualNetworks object = {
  core: {
    resourceId: vnetCore.outputs.resourceId
    name: vnetCore.outputs.name
  }
  mgmt: {
    resourceId: vnetMgmt.outputs.resourceId
    name: vnetMgmt.outputs.name
  }
  user: {
    resourceId: vnetUser.outputs.resourceId
    name: vnetUser.outputs.name
  }
}
