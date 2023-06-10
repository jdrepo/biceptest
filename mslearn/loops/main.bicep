@description('The Azure regions into which the resources should be deployed.')
param locations array = [
  'westeurope'
  'eastus2'
  'eastasia'
]

@description('The Azure regions into which the resources should be deployed.')
param locations2 array = [
  {
    location: 'westeurope'
    prefix: '10.1.0.0/16'
    subnets: [{
      prefix: '10.1.1.0/24' 
      sname: 'subnet1'
    }
    {
      prefix: '10.1.2.0/24' 
      sname: 'subnet2'
    }]
  }
  {
    location: 'eastus2'
    prefix: '10.2.0.0/16'
    subnets: [{
      prefix: '10.2.1.0/24' 
      sname: 'subnet1'
    }
    {
      prefix: '10.2.2.0/24' 
      sname: 'subnet2'
    }]
  }
  {
    location: 'eastasia'
    prefix: '10.3.0.0/16'
    subnets: [{
      prefix: '10.3.1.0/24' 
      sname: 'subnet1'
    }
    {
      prefix: '10.3.2.0/24' 
      sname: 'subnet2'
    }]
  }
]


resource virtualNetworks2 'Microsoft.Network/virtualNetworks@2021-08-01' = [for (location2, i) in locations2: {
  name: 'teddybear2-${location2.location}'
  location: location2.location
  properties:{
    addressSpace:{
      addressPrefixes:[
        location2.prefix
      ]
    }
    subnets: [for subnet in location2.subnets : {
      name: subnet.sname
      properties: {
        addressPrefix: subnet.prefix
      }
    }]
  }
}]


@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdministratorLoginPassword string

@description('The IP address range for all virtual networks to use.')
param virtualNetworkAddressPrefix string = '10.10.0.0/16'

@description('The name and IP address range for each subnet in the virtual networks.')
param subnets array = [
  {
    name: 'frontend'
    ipAddressRange: '10.10.5.0/24'
  }
  {
    name: 'backend'
    ipAddressRange: '10.10.10.0/24'
  }
]

var subnetProperties = [for subnet in subnets: {
  name: subnet.name
  properties: {
    addressPrefix: subnet.ipAddressRange
  }
}]

module databases 'modules/database.bicep' = [for location in locations: {
  name: 'database-${location}'
  params: {
    location: location
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorLoginPassword: sqlServerAdministratorLoginPassword
  }
}]

resource virtualNetworks 'Microsoft.Network/virtualNetworks@2021-08-01' = [for location in locations: {
  name: 'teddybear-${location}'
  location: location
  properties:{
    addressSpace:{
      addressPrefixes:[
        virtualNetworkAddressPrefix
      ]
    }
    subnets: subnetProperties
  }
}]

output serverInfo array = [for i in range(0, length(locations)): {
  name: databases[i].outputs.serverName
  location: databases[i].outputs.location
  fullyQualifiedDomainName: databases[i].outputs.serverFullyQualifiedDomainName
}]
