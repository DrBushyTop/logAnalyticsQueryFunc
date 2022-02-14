param global object = {
  environment: 'trainee-prod'
  location: 'westeurope'
}
param buildId string = utcNow()
param externalLogAnalyticsResourceId string = '/subscriptions/ede0939c-80c4-4dfe-bf3d-84521f3f6d1f/resourcegroups/totalrequests/providers/microsoft.operationalinsights/workspaces/totalrequestssink-la'

var naming = {
  appInsights: '${global.environment}-appi'
  funcStorage: toLower(replace('${global.environment}sto', '-', ''))
  funcAppPlan: '${global.environment}-plan'
  funcApp: '${global.environment}-function'
  keyVault: toLower(replace('${global.environment}-kv', '-', ''))
}

var logAnalyticsResourceGroup = split(externalLogAnalyticsResourceId, '/')[4]

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
    externalLogAnalyticsResourceId: externalLogAnalyticsResourceId
    global: global
    naming: naming
  }
  dependsOn: [
    common
  ]
}

module permissions 'permissions.bicep' = {
  name: 'permissions-${buildId}'
  params: {
    externalLogAnalyticsResourceId: externalLogAnalyticsResourceId
    functionIdentityObjectId: app.outputs.functionIdentityObjectId
  }
  scope: resourceGroup(logAnalyticsResourceGroup)
}
