@description('Specifies the keyvault resource as scope for the roleAssignment.')
param kvScope string

@description('Specifies the object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Get it by using Get-AzADUser or Get-AzADServicePrincipal cmdlets.')
param kvObjectId string

@description('Specifies the role the user will get with the secret in the vault. Valid values are: Key Vault Administrator, Key Vault Certificates Officer, Key Vault Crypto Officer, Key Vault Crypto Service Encryption User, Key Vault Crypto User, Key Vault Reader, Key Vault Secrets Officer, Key Vault Secrets User.')
@allowed([
  'Key Vault Administrator'
  'Key Vault Certificates Officer'
  'Key Vault Crypto Officer'
  'Key Vault Crypto Service Encryption User'
  'Key Vault Crypto User'
  'Key Vault Reader'
  'Key Vault Secrets Officer'
  'Key Vault Secrets User'
])
param kvRoleName string

var roleIdMapping = {
  'Key Vault Administrator': '00482a5a-887f-4fb3-b363-3b7fe8e74483'
  'Key Vault Certificates Officer': 'a4417e6f-fecd-4de8-b567-7b0420556985'
  'Key Vault Crypto Officer': '14b46e9e-c2b7-41b4-b07b-48a6ebf60603'
  'Key Vault Crypto Service Encryption User': 'e147488a-f6f5-4113-8e2d-b22465e65bf6'
  'Key Vault Crypto User': '12338af0-0e69-4776-bea7-57ae8d297424'
  'Key Vault Reader': '21090545-7ca7-4776-b22c-e363652d74d2'
  'Key Vault Secrets Officer': 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
  'Key Vault Secrets User': '4633458b-17de-408a-b874-0445c86b69e6'
}

resource kvRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(roleIdMapping[kvRoleName],kvObjectId,subscription().id)
  scope: kvScope
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleIdMapping[kvRoleName])
    principalId: kvObjectId
    principalType: 'ServicePrincipal'
  }
}
