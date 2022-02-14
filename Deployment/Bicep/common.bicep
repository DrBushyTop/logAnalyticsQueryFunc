param global object
param naming object
param externalLogAnalyticsResourceId string

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: naming.appInsights
  location: global.location
  kind: 'web'
  properties: {
    WorkspaceResourceId: externalLogAnalyticsResourceId
    Application_Type: 'web'
  }
}
