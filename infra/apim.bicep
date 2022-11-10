param service_PamelasChainFunction_apim_name string = 'PamelasChainFunction-apim'
param components_pamelaschainfunction_externalid string = '/subscriptions/74feb6f3-f646-478d-a99b-37fafee75e29/resourceGroups/pamelaschainfunction/providers/Microsoft.Insights/components/pamelaschainfunction'

resource service_PamelasChainFunction_apim_name_resource 'Microsoft.ApiManagement/service@2021-12-01-preview' = {
  name: service_PamelasChainFunction_apim_name
  location: 'West US 2'
  sku: {
    name: 'Consumption'
    capacity: 0
  }
  properties: {
    publisherEmail: 'pamela.fox@gmail.com'
    publisherName: 'Pamela\'s Functions'
    notificationSenderEmail: 'apimgmt-noreply@mail.windowsazure.com'
    hostnameConfigurations: [
      {
        type: 'Proxy'
        hostName: 'pamelaschainfunction-apim.azure-api.net'
        negotiateClientCertificate: false
        defaultSslBinding: true
        certificateSource: 'BuiltIn'
      }
    ]
    customProperties: {
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': 'false'
    }
    virtualNetworkType: 'None'
    enableClientCertificate: false
    disableGateway: false
    apiVersionConstraint: {
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource service_PamelasChainFunction_apim_name_pamelaschainfunction 'Microsoft.ApiManagement/service/apis@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'pamelaschainfunction'
  properties: {
    displayName: 'PamelasChainFunction'
    apiRevision: '1'
    description: 'Import from "PamelasChainFunction" Function App'
    subscriptionRequired: true
    path: 'PamelasChainFunction'
    protocols: [
      'https'
    ]
    authenticationSettings: {
    }
    subscriptionKeyParameterNames: {
      header: 'Ocp-Apim-Subscription-Key'
      query: 'subscription-key'
    }
    isCurrent: true
  }
}

resource Microsoft_ApiManagement_service_backends_service_PamelasChainFunction_apim_name_pamelaschainfunction 'Microsoft.ApiManagement/service/backends@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'pamelaschainfunction'
  properties: {
    description: 'PamelasChainFunction'
    url: 'https://pamelaschainfunction.azurewebsites.net/api'
    protocol: 'http'
    resourceId: 'https://management.azure.com/subscriptions/74feb6f3-f646-478d-a99b-37fafee75e29/resourceGroups/pamelaschainfunction/providers/Microsoft.Web/sites/PamelasChainFunction'
    credentials: {
      header: {
        'x-functions-key': [
          '{{pamelaschainfunction-key}}'
        ]
      }
    }
  }
}

resource Microsoft_ApiManagement_service_loggers_service_PamelasChainFunction_apim_name_pamelaschainfunction 'Microsoft.ApiManagement/service/loggers@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'pamelaschainfunction'
  properties: {
    loggerType: 'applicationInsights'
    credentials: {
      instrumentationKey: '{{Logger-Credentials--62df5d7e200ea717445d700a}}'
    }
    isBuffered: true
    resourceId: components_pamelaschainfunction_externalid
  }
}

resource service_PamelasChainFunction_apim_name_62df5d7e200ea717445d7009 'Microsoft.ApiManagement/service/namedValues@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: '62df5d7e200ea717445d7009'
  properties: {
    displayName: 'Logger-Credentials--62df5d7e200ea717445d700a'
    secret: true
  }
}

resource service_PamelasChainFunction_apim_name_pamelaschainfunction_key 'Microsoft.ApiManagement/service/namedValues@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'pamelaschainfunction-key'
  properties: {
    displayName: 'pamelaschainfunction-key'
    tags: [
      'key'
      'function'
      'auto'
    ]
    secret: true
  }
}

resource service_PamelasChainFunction_apim_name_policy 'Microsoft.ApiManagement/service/policies@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'policy'
  properties: {
    value: '<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - Only the <forward-request> policy element can appear within the <backend> section element.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy position the cursor at the desired insertion point and click on the round button associated with the policy.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n-->\r\n<policies>\r\n  <inbound></inbound>\r\n  <backend>\r\n    <forward-request />\r\n  </backend>\r\n  <outbound></outbound>\r\n</policies>'
    format: 'xml'
  }
}

resource Microsoft_ApiManagement_service_properties_service_PamelasChainFunction_apim_name_62df5d7e200ea717445d7009 'Microsoft.ApiManagement/service/properties@2019-01-01' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: '62df5d7e200ea717445d7009'
  properties: {
    displayName: 'Logger-Credentials--62df5d7e200ea717445d700a'
    value: '30c48d81-4bf6-45c1-8f60-1937caef2a3b'
    secret: true
  }
}

resource Microsoft_ApiManagement_service_properties_service_PamelasChainFunction_apim_name_pamelaschainfunction_key 'Microsoft.ApiManagement/service/properties@2019-01-01' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'pamelaschainfunction-key'
  properties: {
    displayName: 'pamelaschainfunction-key'
    value: '/l31iJBZSKFLax4gRxXCKHfvvsRilu5lbPE14iDnYV2e7t4YcARryQ=='
    tags: [
      'key'
      'function'
      'auto'
    ]
    secret: true
  }
}

resource service_PamelasChainFunction_apim_name_master 'Microsoft.ApiManagement/service/subscriptions@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'master'
  properties: {
    scope: '${service_PamelasChainFunction_apim_name_resource.id}/'
    displayName: 'Built-in all-access subscription'
    state: 'active'
    allowTracing: false
  }
}

resource service_PamelasChainFunction_apim_name_pamelaschainfunction_get_chainfunction 'Microsoft.ApiManagement/service/apis/operations@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_pamelaschainfunction
  name: 'get-chainfunction'
  properties: {
    displayName: 'ChainFunction'
    method: 'GET'
    urlTemplate: '/ChainFunction'
    templateParameters: []
    request: {
      queryParameters: [
        {
          name: 'kind'
          description: 'Specifies which chain to query.'
          type: 'string'
          required: true
          values: [
            'planet'
          ]
        }
        {
          name: 'seed'
          description: 'Specifies seed for random number generator.'
          type: 'integer'
          values: []
        }
      ]
      headers: []
      representations: []
    }
    responses: []
  }
  dependsOn: [

    service_PamelasChainFunction_apim_name_resource
  ]
}

resource service_PamelasChainFunction_apim_name_applicationinsights 'Microsoft.ApiManagement/service/diagnostics@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'applicationinsights'
  properties: {
    alwaysLog: 'allErrors'
    httpCorrelationProtocol: 'Legacy'
    logClientIp: true
    loggerId: Microsoft_ApiManagement_service_loggers_service_PamelasChainFunction_apim_name_pamelaschainfunction.id
    sampling: {
      samplingType: 'fixed'
      percentage: 100
    }
    frontend: {
      request: {
        dataMasking: {
          queryParams: [
            {
              value: '*'
              mode: 'Hide'
            }
          ]
        }
      }
    }
    backend: {
      request: {
        dataMasking: {
          queryParams: [
            {
              value: '*'
              mode: 'Hide'
            }
          ]
        }
      }
    }
  }
}

resource service_PamelasChainFunction_apim_name_applicationinsights_pamelaschainfunction 'Microsoft.ApiManagement/service/diagnostics/loggers@2018-01-01' = {
  parent: service_PamelasChainFunction_apim_name_applicationinsights
  name: 'pamelaschainfunction'
  dependsOn: [

    service_PamelasChainFunction_apim_name_resource
  ]
}

resource service_PamelasChainFunction_apim_name_eliott_fantasy_planet 'Microsoft.ApiManagement/service/subscriptions@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'eliott-fantasy-planet'
  properties: {
    scope: service_PamelasChainFunction_apim_name_pamelaschainfunction.id
    displayName: 'Eliott\'s Fantasy Planet'
    state: 'active'
    allowTracing: true
  }
}

resource service_PamelasChainFunction_apim_name_pamelaschainfunction_applicationinsights 'Microsoft.ApiManagement/service/apis/diagnostics@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_pamelaschainfunction
  name: 'applicationinsights'
  properties: {
    alwaysLog: 'allErrors'
    httpCorrelationProtocol: 'Legacy'
    logClientIp: true
    loggerId: Microsoft_ApiManagement_service_loggers_service_PamelasChainFunction_apim_name_pamelaschainfunction.id
    sampling: {
      samplingType: 'fixed'
      percentage: 100
    }
    frontend: {
      request: {
        dataMasking: {
          queryParams: [
            {
              value: '*'
              mode: 'Hide'
            }
          ]
        }
      }
    }
    backend: {
      request: {
        dataMasking: {
          queryParams: [
            {
              value: '*'
              mode: 'Hide'
            }
          ]
        }
      }
    }
  }
  dependsOn: [

    service_PamelasChainFunction_apim_name_resource

  ]
}

resource service_PamelasChainFunction_apim_name_pamelaschainfunction_applicationinsights_pamelaschainfunction 'Microsoft.ApiManagement/service/apis/diagnostics/loggers@2018-01-01' = {
  parent: service_PamelasChainFunction_apim_name_pamelaschainfunction_applicationinsights
  name: 'pamelaschainfunction'
  dependsOn: [

    service_PamelasChainFunction_apim_name_pamelaschainfunction
    service_PamelasChainFunction_apim_name_resource
  ]
}

resource service_PamelasChainFunction_apim_name_pamelaschainfunction_get_chainfunction_policy 'Microsoft.ApiManagement/service/apis/operations/policies@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_pamelaschainfunction_get_chainfunction
  name: 'policy'
  properties: {
    value: '<policies>\r\n  <inbound>\r\n    <base />\r\n    <set-backend-service id="apim-generated-policy" backend-id="pamelaschainfunction" />\r\n    <cors allow-credentials="false">\r\n      <allowed-origins>\r\n        <origin>http://fantasy-planet.us-west-1.elasticbeanstalk.com</origin>\r\n        <origin>http://eliottgray.com</origin>\r\n        <origin>https://pamelafox.github.io</origin>\r\n        <origin>https://eliottgray.github.io</origin>\r\n      </allowed-origins>\r\n      <allowed-methods>\r\n        <method>GET</method>\r\n      </allowed-methods>\r\n    </cors>\r\n    <validate-parameters specified-parameter-action="prevent" unspecified-parameter-action="ignore" />\r\n  </inbound>\r\n  <backend>\r\n    <base />\r\n  </backend>\r\n  <outbound>\r\n    <base />\r\n  </outbound>\r\n  <on-error>\r\n    <base />\r\n  </on-error>\r\n</policies>'
    format: 'xml'
  }
  dependsOn: [

    service_PamelasChainFunction_apim_name_pamelaschainfunction
    service_PamelasChainFunction_apim_name_resource
  ]
}
