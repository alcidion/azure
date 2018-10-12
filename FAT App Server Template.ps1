{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "newVMName": {
      "type": "string",
      "defaultValue": "TGT-NT"
    },
    "labName": {
      "type": "string",
      "defaultValue": "DELIVERY-TEAM"
    },
    "size": {
      "type": "string",
      "defaultValue": "Standard_B2ms"
    },
    "userName": {
      "type": "string",
      "defaultValue": "acmadin"
    },
    "password": {
      "type": "securestring"
    }
  },
  "variables": {
    "labSubnetName": "DtlDelivery-Subnet",
    "labVirtualNetworkId": "[resourceId('Microsoft.DevTestLab/labs/virtualnetworks', parameters('labName'), variables('labVirtualNetworkName'))]",
    "labVirtualNetworkName": "[concat('Dtl', parameters('labName'))]",
    "vmId": "[resourceId ('Microsoft.DevTestLab/labs/virtualmachines', parameters('labName'), parameters('newVMName'))]",
    "vmName": "[concat(parameters('labName'), '/', parameters('newVMName'))]"
  },
  "resources": [
    {
      "apiVersion": "2018-10-15-preview",
      "type": "Microsoft.DevTestLab/labs/virtualmachines",
      "name": "[variables('vmName')]",
      "location": "[resourceGroup().location]",
      "properties": {
        "labVirtualNetworkId": "[variables('labVirtualNetworkId')]",
        "notes": "Windows Server 2016 Datacenter",
        "galleryImageReference": {
          "offer": "WindowsServer",
          "publisher": "MicrosoftWindowsServer",
          "sku": "2016-Datacenter",
          "osType": "Windows",
          "version": "latest"
        },
        "size": "[parameters('size')]",
        "userName": "[parameters('userName')]",
        "password": "[parameters('password')]",
        "isAuthenticationWithSshKey": false,
        "artifacts": [
          {
            "artifactId": "[resourceId('Microsoft.DevTestLab/labs/artifactSources/artifacts', parameters('labName'), 'public repo', 'windows-iis')]"
          },
          {
            "artifactId": "[resourceId('Microsoft.DevTestLab/labs/artifactSources/artifacts', parameters('labName'), 'public repo', 'windows-chrome')]"
          },
          {
            "artifactId": "[resourceId('Microsoft.DevTestLab/labs/artifactSources/artifacts', parameters('labName'), 'public repo', 'windows-notepadplusplus')]"
          }
        ],
        "labSubnetName": "[variables('labSubnetName')]",
        "disallowPublicIpAddress": true,
        "storageType": "Standard",
        "allowClaim": true
      }
    }
  ],
  "outputs": {
    "labVMId": {
      "type": "string",
      "value": "[variables('vmId')]"
    }
  }
}