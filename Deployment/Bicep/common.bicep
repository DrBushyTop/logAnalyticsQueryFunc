param global object
param naming object
param externalLogAnalyticsResourceId string

// Rather point AI to centralized Log Analytics per logging strategy
// resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
//   name: naming.logAnalytics
//   location: global.location
//   properties: {
//     sku: {
//       name: 'PerGB2018'
//     }
//     retentionInDays: 30
//   }
// }

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: naming.appInsights
  location: global.location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: externalLogAnalyticsResourceId
  }
}

// Action Group

// Alerts
