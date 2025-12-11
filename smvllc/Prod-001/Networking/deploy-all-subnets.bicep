metadata name = 'Prod-001 Deploy All Subnets'
metadata description = 'Deploys all subnets for Prod-001 environment as AVM subnet modules.'

@description('Required. Naming prefix for all resources.')
param namePrefix string

@description('Optional. Environment/location code (e.g., use2 for US East 2).')
param environmentCode string = 'use2'

@description('Optional. Environment type (e.g., nonprod, prod).')
param environmentType string = 'prod'

// location and tags are not passed to the AVM subnet module version in use

// Note: `location` and `tags` are intentionally not declared here
// because the AVM subnet module in use does not accept them as parameters.

// Naming convention
var namingConvention = '${namePrefix}-${environmentCode}-${environmentType}'

// VNet names (derived)
var vnetNames = {
  core: '${namingConvention}-vnet-core-001'
  mgmt: '${namingConvention}-vnet-mgmt-001'
  user: '${namingConvention}-vnet-user-001'
  shared: '${namingConvention}-vnet-shared-001'
  sharedExt: '${namingConvention}-vnet-shared-ext-001'
}

// NSG names (must match those created by the NSG module)
var nsgNames = {
  coreAppExt: '${namingConvention}-nsg-app-ext-001'
  coreAppInt: '${namingConvention}-nsg-app-int-001'
  coreDb: '${namingConvention}-nsg-db-001'
  mgmt: '${namingConvention}-nsg-mgmt-001'
  pep: '${namingConvention}-nsg-pep-001'
  user: '${namingConvention}-nsg-user-001'
  shared: '${namingConvention}-nsg-shared-001'
  sharedPep: '${namingConvention}-nsg-shared-pep-001'
  sharedExt: '${namingConvention}-nsg-shared-ext-001'
}

// Route table names (must match route table module)
var rtNames = {
  coreAppExt: '${namingConvention}-rt-app-ext-001'
  coreAppInt: '${namingConvention}-rt-app-int-001'
  coreDb: '${namingConvention}-rt-db-001'
  mgmt: '${namingConvention}-rt-mgmt-001'
  pep: '${namingConvention}-rt-pep-001'
  user: '${namingConvention}-rt-user-001'
  shared: '${namingConvention}-rt-shared-001'
  sharedPep: '${namingConvention}-rt-shared-pep-001'
  sharedExt: '${namingConvention}-rt-shared-ext-001'
}

// Subnet configurations
var subnetConfigs = {
  coreAppExt: {
    name: '${namingConvention}-snet-app-ext-001'
    vnet: 'core'
    addressPrefix: '10.252.2.0/24'
    serviceEndpoints: [
      'Microsoft.Storage'
      'Microsoft.KeyVault'
      'Microsoft.Sql'
      'Microsoft.ServiceBus'
      'Microsoft.EventHub'
    ]
    nsg: 'coreAppExt'
    rt: 'coreAppExt'
  }
  coreAppInt: {
    name: '${namingConvention}-snet-app-int-001'
    vnet: 'core'
    addressPrefix: '10.252.0.0/24'
    serviceEndpoints: [
      'Microsoft.Storage'
      'Microsoft.KeyVault'
      'Microsoft.Sql'
      'Microsoft.ServiceBus'
      'Microsoft.EventHub'
    ]
    nsg: 'coreAppInt'
    rt: 'coreAppInt'
  }
  coreDb: {
    name: '${namingConvention}-snet-db-001'
    vnet: 'core'
    addressPrefix: '10.252.4.0/24'
    serviceEndpoints: ['Microsoft.Storage', 'Microsoft.KeyVault', 'Microsoft.Sql']
    nsg: 'coreDb'
    rt: 'coreDb'
  }
  mgmtMgmt: {
    name: '${namingConvention}-snet-mgmt-001'
    vnet: 'mgmt'
    addressPrefix: '10.252.72.0/24'
    serviceEndpoints: ['Microsoft.Storage', 'Microsoft.KeyVault']
    nsg: 'mgmt'
    rt: 'mgmt'
  }
  mgmtPep: {
    name: '${namingConvention}-snet-pep-001'
    vnet: 'mgmt'
    addressPrefix: '10.252.80.0/24'
    serviceEndpoints: ['Microsoft.Storage']
    nsg: 'pep'
    rt: 'pep'
  }
  userUser: {
    name: '${namingConvention}-snet-user-001'
    vnet: 'user'
    addressPrefix: '10.252.64.0/22'
    serviceEndpoints: ['Microsoft.Storage', 'Microsoft.KeyVault']
    nsg: 'user'
    rt: 'user'
  }
  shared: {
    name: '${namingConvention}-snet-shared-001'
    vnet: 'shared'
    addressPrefix: '10.252.68.0/22'
    serviceEndpoints: ['Microsoft.Storage', 'Microsoft.KeyVault']
    nsg: 'shared'
    rt: 'shared'
  }
  sharedPep: {
    name: '${namingConvention}-snet-shared-pep-001'
    vnet: 'shared'
    addressPrefix: '10.252.90.0/24'
    serviceEndpoints: ['Microsoft.Storage', 'Microsoft.KeyVault']
    nsg: 'sharedPep'
    rt: 'sharedPep'
  }
  sharedExt: {
    name: '${namingConvention}-snet-shared-ext-001'
    vnet: 'sharedExt'
    addressPrefix: '10.252.100.0/24'
    nsg: 'sharedExt'
    rt: 'sharedExt'
  }
}

// Helper functions to build resource IDs for NSGs and Route Tables in current RG
// Inline resourceId calls are used below instead of lambda helpers

// ============================================================================
// Subnet modules (use AVM subnet module version available: 0.1.3)
// ============================================================================

module subnetCoreAppExt 'br/public:avm/res/network/virtual-network/subnet:0.1.3' = {
  name: 'subnet-core-app-ext'
  params: {
    name: subnetConfigs.coreAppExt.name
    virtualNetworkName: vnetNames.core
    addressPrefix: subnetConfigs.coreAppExt.addressPrefix
    networkSecurityGroupResourceId: resourceId('Microsoft.Network/networkSecurityGroups', nsgNames.coreAppExt)
    routeTableResourceId: resourceId('Microsoft.Network/routeTables', rtNames.coreAppExt)
    serviceEndpoints: subnetConfigs.coreAppExt.serviceEndpoints
  }
}

module subnetCoreAppInt 'br/public:avm/res/network/virtual-network/subnet:0.1.3' = {
  name: 'subnet-core-app-int'
  params: {
    name: subnetConfigs.coreAppInt.name
    virtualNetworkName: vnetNames.core
    addressPrefix: subnetConfigs.coreAppInt.addressPrefix
    networkSecurityGroupResourceId: resourceId('Microsoft.Network/networkSecurityGroups', nsgNames.coreAppInt)
    routeTableResourceId: resourceId('Microsoft.Network/routeTables', rtNames.coreAppInt)
    serviceEndpoints: subnetConfigs.coreAppInt.serviceEndpoints
  }
}

module subnetCoreDb 'br/public:avm/res/network/virtual-network/subnet:0.1.3' = {
  name: 'subnet-core-db'
  params: {
    name: subnetConfigs.coreDb.name
    virtualNetworkName: vnetNames.core
    addressPrefix: subnetConfigs.coreDb.addressPrefix
    networkSecurityGroupResourceId: resourceId('Microsoft.Network/networkSecurityGroups', nsgNames.coreDb)
    routeTableResourceId: resourceId('Microsoft.Network/routeTables', rtNames.coreDb)
    serviceEndpoints: subnetConfigs.coreDb.serviceEndpoints
  }
}

module subnetMgmtMgmt 'br/public:avm/res/network/virtual-network/subnet:0.1.3' = {
  name: 'subnet-mgmt-mgmt'
  params: {
    name: subnetConfigs.mgmtMgmt.name
    virtualNetworkName: vnetNames.mgmt
    addressPrefix: subnetConfigs.mgmtMgmt.addressPrefix
    networkSecurityGroupResourceId: resourceId('Microsoft.Network/networkSecurityGroups', nsgNames.mgmt)
    routeTableResourceId: resourceId('Microsoft.Network/routeTables', rtNames.mgmt)
    serviceEndpoints: subnetConfigs.mgmtMgmt.serviceEndpoints
  }
}

module subnetMgmtPep 'br/public:avm/res/network/virtual-network/subnet:0.1.3' = {
  name: 'subnet-mgmt-pep'
  params: {
    name: subnetConfigs.mgmtPep.name
    virtualNetworkName: vnetNames.mgmt
    addressPrefix: subnetConfigs.mgmtPep.addressPrefix
    networkSecurityGroupResourceId: resourceId('Microsoft.Network/networkSecurityGroups', nsgNames.pep)
    routeTableResourceId: resourceId('Microsoft.Network/routeTables', rtNames.pep)
    serviceEndpoints: subnetConfigs.mgmtPep.serviceEndpoints
  }
}
module subnetShared 'br/public:avm/res/network/virtual-network/subnet:0.1.3' = {
  name: 'subnet-shared'
  params: {
    name: subnetConfigs.shared.name
    virtualNetworkName: vnetNames.shared
    addressPrefix: subnetConfigs.shared.addressPrefix
    networkSecurityGroupResourceId: resourceId('Microsoft.Network/networkSecurityGroups', nsgNames.shared)
    routeTableResourceId: resourceId('Microsoft.Network/routeTables', rtNames.shared)
    serviceEndpoints: subnetConfigs.shared.serviceEndpoints
  }
}

module subnetSharedExt 'br/public:avm/res/network/virtual-network/subnet:0.1.3' = {
  name: 'subnet-shared-ext'
  params: {
    name: subnetConfigs.sharedExt.name
    virtualNetworkName: vnetNames.sharedExt
    addressPrefix: subnetConfigs.sharedExt.addressPrefix
    networkSecurityGroupResourceId: resourceId('Microsoft.Network/networkSecurityGroups', nsgNames.sharedExt)
    routeTableResourceId: resourceId('Microsoft.Network/routeTables', rtNames.sharedExt)
  }
}

module subnetSharedPep 'br/public:avm/res/network/virtual-network/subnet:0.1.3' = {
  name: 'subnet-shared-pep'
  params: {
    name: subnetConfigs.sharedPep.name
    virtualNetworkName: vnetNames.shared
    addressPrefix: subnetConfigs.sharedPep.addressPrefix
    networkSecurityGroupResourceId: resourceId('Microsoft.Network/networkSecurityGroups', nsgNames.sharedPep)
    routeTableResourceId: resourceId('Microsoft.Network/routeTables', rtNames.sharedPep)
    serviceEndpoints: subnetConfigs.sharedPep.serviceEndpoints
  }
}

module subnetUserUser 'br/public:avm/res/network/virtual-network/subnet:0.1.3' = {
  name: 'subnet-user-user'
  params: {
    name: subnetConfigs.userUser.name
    virtualNetworkName: vnetNames.user
    addressPrefix: subnetConfigs.userUser.addressPrefix
    networkSecurityGroupResourceId: resourceId('Microsoft.Network/networkSecurityGroups', nsgNames.user)
    routeTableResourceId: resourceId('Microsoft.Network/routeTables', rtNames.user)
    serviceEndpoints: subnetConfigs.userUser.serviceEndpoints
  }
}

// ============================================================================
// OUTPUTS
// ============================================================================

output deployedSubnets object = {
  coreAppExt: {
    resourceId: subnetCoreAppExt.outputs.resourceId
    name: subnetCoreAppExt.outputs.name
  }
  coreAppInt: {
    resourceId: subnetCoreAppInt.outputs.resourceId
    name: subnetCoreAppInt.outputs.name
  }
  coreDb: {
    resourceId: subnetCoreDb.outputs.resourceId
    name: subnetCoreDb.outputs.name
  }
  mgmtMgmt: {
    resourceId: subnetMgmtMgmt.outputs.resourceId
    name: subnetMgmtMgmt.outputs.name
  }
  mgmtPep: {
    resourceId: subnetMgmtPep.outputs.resourceId
    name: subnetMgmtPep.outputs.name
  }
  userUser: {
    resourceId: subnetUserUser.outputs.resourceId
    name: subnetUserUser.outputs.name
  }
  shared: {
    resourceId: subnetShared.outputs.resourceId
    name: subnetShared.outputs.name
  }
  sharedExt: {
    resourceId: subnetSharedExt.outputs.resourceId
    name: subnetSharedExt.outputs.name
  }
  sharedPep: {
    resourceId: subnetSharedPep.outputs.resourceId
    name: subnetSharedPep.outputs.name
  }
}
