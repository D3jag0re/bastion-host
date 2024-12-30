# bastion-host

This is based off the DevOps Roadmap Project [Bastion Host](https://roadmap.sh/projects/bastion-host)

Setup a bastion host for managing access to private infrastructure. 

This is number 18 of [DevOps Projects](https://roadmap.sh/devops/projects) as per roadmap.sh

## Description From Site 

The goal of this project is to learn and practice how to set up a `bastion host` —a secure entry point that enables authorized users to access private infrastructure or internal systems without exposing them to the public internet.

## Requirements

You will set up a bastion host in a cloud environment and configure it to securely allow access to a private server.

- Choose a cloud provider (e.g., AWS, DigitalOcean, GCP, Azure) and create two servers:
    - Bastion Host (publicly accessible).
    - Private Server (accessible only from the bastion host IP address and not publicly).

- Configure both the servers to allow SSH connection and configure SSH in a way that you can SSH into the private server by jumping through the bastion host

``
Host bastion
    HostName <bastion-ip>
    User <bastion-user>
    IdentityFile <path-to-bastion-private-key>

Host private-server
    HostName <private-server-ip>
    User <private-server-user>
    ProxyJump bastion
    IdentityFile <path-to-private-server-private-key>
``

- Connect tothe bastion host using: 
    `ssh bastion   `

- From the bastion host, connect to the private server:
    ` ssh private-server`

- Alternatively, connect directly using your local machine:
    `ssh private-server `

### Stretch Goals


- `Harden Security`: Configure multi-factor authentication (MFA) for the bastion host. Use iptables or similar tools for more granular traffic filtering.
- `Automate Setup`: Use Terraform or Ansible to automate the deployment and configuration of your bastion host and private server.


After completing this project, you will have a strong understanding of how to set up a bastion host and securely manage access to private infrastructure. This foundational knowledge will prepare you for more advanced projects in network and infrastructure security.

## prerequisites

- Setup the following repository secrets:
    - DO_TOKEN : Digital Ocean access token
    - DO_SPACES_SECRET_KEY : Digital Ocean spaces secret key (for Terraform state file)
    - DO_SPACES_ACCESS_KEY : Digital Ocean spaces access key (for Terraform state file)
    - DO_SSH_PUBLIC_KEY : Keypair to be used for VM 
    - DO_SSH_PRIVATE_KEY : Keypair to be used for VM
    - VM_HOST: IP or hostname of VM host

## To Run backup Manually 

- Trigger workflow OR you can:
    - copy backupDB.sh and restoreDB.sh to host VM
    - Run 

## To Run backup Automatically 

- A



## Notes 

- Notes

## Lessons Learned

- Lessons