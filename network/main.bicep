param location string = 'westeurope'

targetScope = 'subscription'

resource rg1 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg1-trash'
  location: location
  tags: {
    tag2: 'tag2'
  }
  
  
}
// Create resource group2

resource rg2 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg2-trash'
  location: location
  tags: {
    tag2: 'tag2'
  }
}


