metadata name = 'Prod-001 Deploy All Network Security Groups'
metadata description = 'Deploys all Network Security Groups for Prod-001 environment (core, mgmt, user, peering-related).'

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

// NSG names
var nsgNames = {
  coreAppExt: '${namingConvention}-nsg-app-ext-001'
  coreAppInt: '${namingConvention}-nsg-app-int-001'
  coreDb: '${namingConvention}-nsg-db-001'
  mgmt: '${namingConvention}-nsg-mgmt-001'
  pep: '${namingConvention}-nsg-pep-001'
  user: '${namingConvention}-nsg-user-001'
}

// ============================================================================
// Network Security Group modules
// ============================================================================

module nsgCoreAppExt 'br/public:avm/res/network/network-security-group:0.5.2' = {
  name: 'nsg-core-app-ext'
  params: {
    name: nsgNames.coreAppExt
    location: location
    tags: tags
    // securityRules can be expanded as needed; provide empty array as safe default
    securityRules: []
  }
}

module nsgCoreAppInt 'br/public:avm/res/network/network-security-group:0.5.2' = {
  name: 'nsg-core-app-int'
  params: {
    name: nsgNames.coreAppInt
    location: location
    tags: tags
    securityRules: []
  }
}

module nsgCoreDb 'br/public:avm/res/network/network-security-group:0.5.2' = {
  name: 'nsg-core-db'
  params: {
    name: nsgNames.coreDb
    location: location
    tags: tags
    securityRules: []
  }
}

module nsgMgmt 'br/public:avm/res/network/network-security-group:0.5.2' = {
  name: 'nsg-mgmt'
  params: {
    name: nsgNames.mgmt
    location: location
    tags: tags
    securityRules: []
  }
}

module nsgPep 'br/public:avm/res/network/network-security-group:0.5.2' = {
  name: 'nsg-pep'
  params: {
    name: nsgNames.pep
    location: location
    tags: tags
    securityRules: []
  }
}

module nsgUser 'br/public:avm/res/network/network-security-group:0.5.2' = {
  name: 'nsg-user'
  params: {
    name: nsgNames.user
    location: location
    tags: tags
    securityRules: []
  }
}

// ============================================================================
// OUTPUTS
// ============================================================================

output deployedNetworkSecurityGroups object = {
  coreAppExt: {
    resourceId: nsgCoreAppExt.outputs.resourceId
    name: nsgCoreAppExt.outputs.name
  }
  coreAppInt: {
    resourceId: nsgCoreAppInt.outputs.resourceId
    name: nsgCoreAppInt.outputs.name
  }
  coreDb: {
    resourceId: nsgCoreDb.outputs.resourceId
    name: nsgCoreDb.outputs.name
  }
  mgmt: {
    resourceId: nsgMgmt.outputs.resourceId
    name: nsgMgmt.outputs.name
  }
  pep: {
    resourceId: nsgPep.outputs.resourceId
    name: nsgPep.outputs.name
  }
  user: {
    resourceId: nsgUser.outputs.resourceId
    name: nsgUser.outputs.name
  }
}
