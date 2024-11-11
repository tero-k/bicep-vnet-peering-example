param allowVirtualNetworkAccess bool
param allowForwardedTraffic bool
param allowGatewayTransit bool
param useRemoteGateways bool
param vnetId string
param vnetName string
param vnetNamePeered string

resource peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-07-01' = {
  name: '${vnetName}/${vnetNamePeered}-peering'
  properties: {
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: allowGatewayTransit
    useRemoteGateways: useRemoteGateways
    remoteVirtualNetwork: {
      id: vnetId
    }
  }
}
