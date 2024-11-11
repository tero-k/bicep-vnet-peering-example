targetScope = 'subscription'

@description('Specifies whether to allow forwarded traffic')
@allowed([
  true
  false
])
param AllowTrafficToVNet1FromVNet2 bool

@description('Specifies whether to allow gateway transit')
@allowed([
  true
  false
])
param AllowForwardingVnet1ToVNet2 bool

@description('Specifies whether to allow virtual network access')
@allowed([
  true
  false
])
param AllowAccessVNet1ToVNet2 bool

@description('Specifies whether to use remote gateways')
@allowed([
  true
  false
])
param EnableRemoteGWVNet1ToVNet2 bool

// VNET 2
@description('Specifies whether to allow forwarded traffic')
@allowed([
  true
  false
])
param AllowTrafficToVNet2FromVNet1 bool

@description('Specifies whether to allow gateway transit')
@allowed([
  true
  false
])
param AllowForwardingVnet2ToVNet1 bool

@description('Specifies whether to allow virtual network access')
@allowed([
  true
  false
])
param AllowAccessVNet2ToVNet1 bool

@description('Specifies whether to use remote gateways')
@allowed([
  true
  false
])
param EnableRemoteGWVNet2ToVNet1 bool

/* VNET 1 Details */
param vnet1SubscriptionId string
param vnet1ResourceGroupName string
param vnet1Name string

/* VNET 2 Details*/
param vnet2SubscriptionId string
param vnet2ResourceGroupName string
param vnet2Name string

/* Import VNET 1 */
resource vnet1 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: vnet1Name
  scope: resourceGroup(vnet1SubscriptionId, vnet1ResourceGroupName)
}

/* Improt VNET 2 */
resource vnet2 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: vnet2Name
  scope: resourceGroup(vnet2SubscriptionId, vnet2ResourceGroupName)
}

/* Create Peering #1 */
module vnet1Peering 'modules/vnet-peering-deployment.bicep' = {
  name: 'deployVnetPeering'
  scope: resourceGroup(vnet2SubscriptionId, vnet2ResourceGroupName)
  params: {
    allowForwardedTraffic: AllowTrafficToVNet2FromVNet1
    allowGatewayTransit: AllowForwardingVnet2ToVNet1
    allowVirtualNetworkAccess: AllowAccessVNet2ToVNet1
    useRemoteGateways: EnableRemoteGWVNet2ToVNet1
    vnetName: vnet2Name
    vnetNamePeered: vnet1Name
    vnetId: vnet1.id
  }
}

/* Create Peering #2 */
module vnet2Peering 'modules/vnet-peering-deployment.bicep' = {
  name: 'deployVnetPeering2'
  scope: resourceGroup(vnet1SubscriptionId, vnet1ResourceGroupName)
  params: {
    allowForwardedTraffic: AllowTrafficToVNet1FromVNet2
    allowGatewayTransit: AllowForwardingVnet1ToVNet2
    allowVirtualNetworkAccess: AllowAccessVNet1ToVNet2
    useRemoteGateways: EnableRemoteGWVNet1ToVNet2
    vnetName: vnet1Name
    vnetNamePeered: vnet2Name
    vnetId: vnet2.id
  }
}
