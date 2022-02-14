param global object
param naming object
@secure()
param exampleSecretValue string

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: naming.keyVault
  location: global.location
  properties: {
    enabledForDeployment: false
    enabledForTemplateDeployment: false
    enabledForDiskEncryption: false
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        // Most likely should just take this in as a parameter as it's already output by the app
        objectId: reference(resourceId('Microsoft.Web/sites', naming.FuncApp)).identity.principalId
        permissions: {
          secrets: [
            'list'
            'get'
          ]
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}

resource exampleSecret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: 'mySecret'
  parent: keyVault
  properties: {
    value: exampleSecretValue
  }
}
