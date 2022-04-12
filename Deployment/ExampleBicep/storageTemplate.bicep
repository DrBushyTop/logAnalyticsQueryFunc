param namePrefix string
param location string

param accountConfig object

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: '${namePrefix}${accountConfig.suffix}'
  location: location
  kind: 'StorageV2'
  sku:{
    name: accountConfig.sku
  }
  properties:{
    accessTier: 'Hot'
  }

  resource blobService 'blobServices' = {
    name: 'default'

    resource containers 'containers' = [for (container, index) in accountConfig.containers: {
      name: container
      properties: {
        publicAccess: 'None'
      }
    }]
  }
}

