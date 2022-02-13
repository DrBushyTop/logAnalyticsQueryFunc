param externalLogAnalyticsResourceId string
param funcAppIdentityObjectId string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' existing = {
  name: split(externalLogAnalyticsResourceId, '/')[length(split(externalLogAnalyticsResourceId, '/'))-1]
  scope: resourceGroup()
}

resource logReader 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid('${funcAppIdentityObjectId}-logReader')
  scope: logAnalytics
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
    principalId: funcAppIdentityObjectId
  }
}
