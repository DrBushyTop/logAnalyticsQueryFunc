param global object = {
  environment: 'trainee-prod'
  location: 'westeurope'
}
param buildId string = utcNow()
param externalLogAnalyticsResourceId string = '/subscriptions/ede0939c-80c4-4dfe-bf3d-84521f3f6d1f/resourcegroups/totalrequests/providers/microsoft.operationalinsights/workspaces/totalrequestssink-la'

var naming = {
  appInsights: '${global.environment}-appi'
  functionStorage: toLower(replace('${global.environment}sto', '-', ''))
  functionAppPlan: '${global.environment}-plan'
  functionApp: '${global.environment}-function'
  keyVault: toLower(replace('${global.environment}-kv', '-', ''))
}

module common 'common.bicep' = {
  name: 'common-${buildId}'
  params: {
    externalLogAnalyticsResourceId: externalLogAnalyticsResourceId 
    global: global
    naming: naming
  }
}

resource storage 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: naming.functionStorage
  location: global.location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
