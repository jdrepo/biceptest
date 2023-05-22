param location string = 'westeurope'

targetScope = 'subscription'

resource rg1 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg1-trash'
  location: location
}
