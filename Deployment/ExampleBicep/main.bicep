param global object = {
  environment: 'phprod'
  location: 'westeurope'
}
param buildId string = utcNow()
param externalLogAnalyticsResourceId string = '/subscriptions/xxx/resourcegroups/totalrequests/providers/microsoft.operationalinsights/workspaces/totalrequestssink-la'

var naming = {
  appInsights: '${global.environment}-appi'
  funcAppPlan: '${global.environment}-fplan'
  funcStorage: replace(toLower('${global.environment}func'), '-', '')
  funcApp: '${global.environment}-func'
  keyVault: replace(toLower('${global.environment}kv'), '-', '')
}

module common 'common.bicep' = {
  name: 'common-${buildId}'
  params: {
    externalLogAnalyticsResourceId: externalLogAnalyticsResourceId
    global: global
    naming: naming
  }
}

module app 'app.bicep' = {
  name: 'app-${buildId}'
  params: {
    global: global
    naming: naming
    externalLogAnalyticsResourceId: externalLogAnalyticsResourceId
  }
  dependsOn:[
    common
  ]
}

module keyvault 'keyvault.bicep' = {
  name: 'keyvault-${buildId}'
  params: {
    global: global
    naming: naming
    exampleSecretValue: 'dontSaveSecretsAsPlainTextLikeThis'
  }
  dependsOn:[
    app
  ]
}

module permissions 'permissions.bicep' = {
  name: 'permissions-${buildId}'
  params: {
    externalLogAnalyticsResourceId: externalLogAnalyticsResourceId
    funcAppIdentityObjectId: app.outputs.funcAppIdentityObjectId
  }
  scope: resourceGroup(split(externalLogAnalyticsResourceId, '/')[4])
}
