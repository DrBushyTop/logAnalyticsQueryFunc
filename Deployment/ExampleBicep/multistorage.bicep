param location string = 'westeurope'
param namePrefix string = 'gdadsfcfsd'
param storageConfig array = [
  {
    suffix: 'envs'
    sku: 'Standard_LRS'
    containers: [
      'dev'
      'test'
      'prod'
    ]
  }
  {
    suffix: 'blobs'
    sku: 'Standard_ZRS'
    containers: [
      'important'
      'cool'
    ]
  }
  {
    suffix: 'ar'
    sku: 'Standard_GRS'
    containers: [
      'delete'
    ]
  }
]

module storageAccounts 'storageTemplate.bicep' = [for (account, index) in storageConfig: if (account.sku != 'Standard_ZRS') {
  name: 'storage${index}'
  params: {
    namePrefix: namePrefix
    location: location
    accountConfig: account
  }
}]
