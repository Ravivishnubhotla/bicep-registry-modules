metadata name = 'NonProd-001 Route Tables Composite'
metadata description = 'This module deploys all route tables for NonProd-001 networking.'

@description('Required. Naming prefix for all resources.')
param namePrefix string

@description('Optional. Environment/location code (e.g., use2 for US East 2).')
param environmentCode string = 'use2'

@description('Optional. Environment type (e.g., nonprod, prod).')
param environmentType string = 'nonprod'

@description('Optional. Firewall IP address for route tables.')
param firewallipaddress string = '0.0.0.0'

@description('Tags for all resources.')
param tags object = {
  Domain: 'Infrastructure'
  DomainOwner: 'ravi.vishnubhotla2@gmail.com'
  LifeCycle: 'Non-Prod'
}

// Deploy all route tables
module routeTableCoreAppExt 'br/public:avm/res/network/route-table:0.5.0' = {
  name: 'rt-core-app-ext-001'
  params: {
    name: '${namePrefix}-${environmentCode}-${environmentType}-rt-app-ext-001'
    location: resourceGroup().location
    tags: tags
    routes: [
      {
        name: 'DEFAULT_FIREWALL'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallipaddress
        }
      }
    ]
  }
}

module routeTableCoreAppInt 'br/public:avm/res/network/route-table:0.5.0' = {
  name: 'rt-core-app-int-001'
  params: {
    name: '${namePrefix}-${environmentCode}-${environmentType}-rt-app-int-001'
    location: resourceGroup().location
    tags: tags
    routes: [
      {
        name: 'DEFAULT_FIREWALL'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallipaddress
        }
      }
    ]
  }
}

module routeTableCoreDb 'br/public:avm/res/network/route-table:0.5.0' = {
  name: 'rt-core-db-001'
  params: {
    name: '${namePrefix}-${environmentCode}-${environmentType}-rt-db-001'
    location: resourceGroup().location
    tags: tags
    routes: [
      {
        name: 'DEFAULT_FIREWALL'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallipaddress
        }
      }
    ]
  }
}

module routeTableMgmt 'br/public:avm/res/network/route-table:0.5.0' = {
  name: 'rt-mgmt-001'
  params: {
    name: '${namePrefix}-${environmentCode}-${environmentType}-rt-mgmt-001'
    location: resourceGroup().location
    tags: tags
    routes: [
      {
        name: 'DEFAULT_FIREWALL'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallipaddress
        }
      }
    ]
  }
}

module routeTablePep 'br/public:avm/res/network/route-table:0.5.0' = {
  name: 'rt-pep-001'
  params: {
    name: '${namePrefix}-${environmentCode}-${environmentType}-rt-pep-001'
    location: resourceGroup().location
    tags: tags
    routes: [
      {
        name: 'DEFAULT_FIREWALL'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallipaddress
        }
      }
    ]
  }
}

module routeTableUser 'br/public:avm/res/network/route-table:0.5.0' = {
  name: 'rt-user-001'
  params: {
    name: '${namePrefix}-${environmentCode}-${environmentType}-rt-user-001'
    location: resourceGroup().location
    tags: tags
    routes: [
      {
        name: 'DEFAULT_FIREWALL'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallipaddress
        }
      }
    ]
  }
}
