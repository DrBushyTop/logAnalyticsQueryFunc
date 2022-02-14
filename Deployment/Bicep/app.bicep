param global object
param naming object
param externalLogAnalyticsResourceId string

resource funcStorage 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: naming.functionStorage
  location: global.location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource funcPlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: naming.funcAppPlan
  location: global.location
  sku: {
    name: 'Y1'
  }
  properties: {}
}

resource funcApp 'Microsoft.Web/sites@2020-12-01' = {
  name: naming.funcApp
  location: global.location
  kind: 'functionapp'
  properties: {
    serverFarmId: funcPlan.id
    httpsOnly: true
    siteConfig: {
      use32BitWorkerProcess: false
    }
  }
}

resource funcAppSettings 'Microsoft.Web/sites/config@2021-03-01' = {
  name: 'appsettings'
  parent: funcApp
  properties: {
      'AzureWebJobsDashboard': 'DefaultEndpointsProtocol=https;AccountName=${funcStorage.name};AccountKey=${listKeys(funcStorage.id, '2021-08-01').keys[0].value}'
      'AzureWebJobsStorage': 'DefaultEndpointsProtocol=https;AccountName=${funcStorage.name};AccountKey=${listKeys(funcStorage.id, '2021-08-01').keys[0].value}'
      'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING': 'DefaultEndpointsProtocol=https;AccountName=${funcStorage.name};AccountKey=${listKeys(funcStorage.id, '2021-08-01').keys[0].value}'
      'WEBSITE_CONTENTSHARE': toLower(naming.funcApp)
      'FUNCTIONS_EXTENSION_VERSION': '~4'
      'APPINSIGHTS_INSTRUMENTATIONKEY': reference(resourceId('Microsoft.Insights/components', naming.appInsights), '2020-02-02-preview').InstrumentationKey
      'FUNCTIONS_WORKER_RUNTIME': 'dotnet'
      'WEBSITE_RUN_FROM_PACKAGE': '1'
      'WORKSPACE_ID': reference(externalLogAnalyticsResourceId, '2021-12-01-preview').customerId
      'KEYVAULT_URL': 'https://${naming.keyVault}.vault.azure.net/'
  }
}
