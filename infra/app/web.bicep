param environmentName string
param location string = resourceGroup().location

param applicationInsightsName string = ''
param containerAppsEnvironmentName string = ''
param containerRegistryName string = ''
param imageName string = ''
param keyVaultName string = ''
param serviceName string = 'web'

var abbrs = loadJsonContent('../abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

module web '../core/host/container-app.bicep' = {
  name: '${serviceName}-container-app-module'
  params: {
    environmentName: environmentName
    location: location
    containerAppsEnvironmentName: containerAppsEnvironmentName
    containerRegistryName: containerRegistryName
    env: [
      {
        name: 'REACT_APP_APPLICATIONINSIGHTS_CONNECTION_STRING'
        value: applicationInsights.properties.ConnectionString
      }
      {
        name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
        value: applicationInsights.properties.ConnectionString
      }
    ]
    imageName: !empty(imageName) ? imageName : 'nginx:latest'
    serviceName: serviceName
    targetPort: 3001
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: !empty(applicationInsightsName) ? applicationInsightsName : '${abbrs.insightsComponents}${resourceToken}'
}

output WEB_NAME string = web.outputs.name
output WEB_URI string = web.outputs.uri
