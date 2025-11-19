# CycleCloud Azure Infrastructure Setup

This repository contains scripts and configurations for deploying the ancillary Azure infrastructure services required by CycleCloud.

## Overview

CycleCloud requires several Azure services to operate effectively. This script automates the deployment of core infrastructure components including networking, storage, and access management services.

## Prerequisites

- Azure CLI installed and configured
- Active Azure subscription
- Appropriate permissions to create resources and assign roles
- Bash shell environment

## Services Deployed

### Core Infrastructure
- **Resource Group**: Dedicated resource group for CycleCloud resources
- **Virtual Network**: Network infrastructure with proper subnet configuration
- **Storage Account**: Blob storage for CycleCloud data and configurations
- **Azure Bastion**: Secure access to virtual machines without public IPs

### Security and Access Management
- **Application Registration**: Service principal for CycleCloud authentication
- **Role Assignments**: Proper permissions for resource management
- **Client Credentials**: Secure authentication tokens

## Quick Start

1. Clone this repository:
```bash
git clone <repository-url>
cd cyclecloud-azure-setup
```

2. Review and modify variables in the script if needed:
```bash
vim deploy-infrastructure.sh
```

3. Run the deployment script:
```bash
chmod +x deploy-infrastructure.sh
./deploy-infrastructure.sh
```

## Configuration

### Default Settings

| Component | Default Value | Description |
|-----------|---------------|-------------|
| Resource Group | `cycle-cloud-prod` | Main resource group name |
| Location | `eastus` | Azure region |
| Virtual Network | `cc-demo` | VNet name |
| Address Space | `10.0.0.0/16` | VNet address range |
| Default Subnet | `10.0.1.0/24` | Main subnet range |
| Bastion Subnet | `10.0.2.0/24` | Azure Bastion subnet |
| Storage SKU | `Standard_LRS` | Storage account type |

### Customization

To customize the deployment, modify the variables at the top of `deploy-infrastructure.sh`:

```bash
RESOURCE_GROUP="your-resource-group-name"
LOCATION="your-preferred-region"
VNET_NAME="your-vnet-name"
# ... other variables
```

## Network Architecture

```
Virtual Network (10.0.0.0/16)
├── Default Subnet (10.0.1.0/24)
│   └── CycleCloud VMs and compute resources
└── AzureBastionSubnet (10.0.2.0/24)
    └── Azure Bastion Host
```

## Security Considerations

- Storage account is configured with HTTPS-only access
- Azure Bastion provides secure VM access without public IPs
- Service principal follows principle of least privilege
- Network security groups should be configured post-deployment

## Post-Deployment Steps

After running the script, you'll need to:

1. **Configure Network Security Groups**: Set up appropriate firewall rules
2. **Deploy CycleCloud**: Install and configure the CycleCloud application
3. **Set up Compute Images**: Prepare VM images for your workloads
4. **Configure Authentication**: Set up user authentication and authorization

## Troubleshooting

### Common Issues

**Permission Errors**
- Ensure your Azure CLI session has sufficient privileges
- Verify subscription-level permissions for creating resources

**Naming Conflicts**
- Storage account names must be globally unique
- The script includes a timestamp to avoid conflicts

**Network Configuration**
- Ensure address ranges don't conflict with existing networks
- Verify subnet sizes are appropriate for your workload

### Cleanup

To remove all created resources:

```bash
az group delete --name cycle-cloud-prod --yes --no-wait
az ad app delete --id 55ed6109-4636-403d-bece-65c4ed51131a
```

## Service Principal Information

The script creates an application registration with the following details:
- **Display Name**: CCApp
- **Application ID**: 55ed6109-4636-403d-bece-65c4ed51131a
- **Role Assignment**: Contributor access to the subscription

**Important**: Store the generated client secret securely as it cannot be retrieved later.

## Monitoring and Maintenance

- Monitor storage account usage and costs
- Review role assignments periodically
- Update network security rules as needed
- Keep Azure Bastion updated with latest features

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly in a development environment
5. Submit a pull request

## Support

For issues related to:
- **Azure Services**: Consult Azure documentation or support
- **CycleCloud**: Refer to Microsoft CycleCloud documentation
- **This Script**: Open an issue in this repository

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Microsoft Azure CycleCloud team for architecture guidance
- Azure CLI team for comprehensive tooling