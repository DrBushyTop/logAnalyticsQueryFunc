param externalLogAnalyticsResourceId string
param functionIdentityObjectId string

var logAnalyticsName = split(externalLogAnalyticsResourceId, '/')[length(split(externalLogAnalyticsResourceId, '/'))-1]

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' existing = {
  name: logAnalyticsName
  scope: resourceGroup()
}

resource logAnalyticsReader 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid('${functionIdentityObjectId}-loganalyticsreader2')
  scope: logAnalytics
  properties: {
    principalId: functionIdentityObjectId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleAssignments', '73c42c96-874c-492b-b04d-ab87d138a893')
  }
}
