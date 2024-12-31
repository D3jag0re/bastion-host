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

```
Host bastion
    HostName <bastion-ip>
    User <bastion-user>
    IdentityFile <path-to-bastion-private-key>

Host private-server
    HostName <private-server-ip>
    User <private-server-user>
    ProxyJump bastion
    IdentityFile <path-to-private-server-private-key>
```

- Connect tothe bastion host using: 
    `ssh bastion   `

- From the bastion host, connect to the private server:
    ` ssh private-server`

- Alternatively, connect directly using your local machine:
    `ssh private-server `

### Stretch Goals


- [] `Harden Security`: Configure multi-factor authentication (MFA) for the bastion host. Use iptables or similar tools for more granular traffic filtering.
- [X] `Automate Setup`: Use Terraform or Ansible to automate the deployment and configuration of your bastion host and private server.


After completing this project, you will have a strong understanding of how to set up a bastion host and securely manage access to private infrastructure. This foundational knowledge will prepare you for more advanced projects in network and infrastructure security.

## prerequisites

- Setup the following repository secrets:
    - DO_TOKEN : Digital Ocean access token
    - DO_SPACES_SECRET_KEY : Digital Ocean spaces secret key (for Terraform state file)
    - DO_SPACES_ACCESS_KEY : Digital Ocean spaces access key (for Terraform state file)
    - DO_SSH_PUBLIC_KEY_BASTION : Keypair to be used for Bastion Host VM 
    - DO_SSH_PRIVATE_KEY_BASTION : Keypair to be used for Bastion Host VM
    - DO_SSH_PUBLIC_KEY_PRIVATE : Keypair to be used for Private VM 
    - DO_SSH_PRIVATE_KEY_PRIVATE : Keypair to be used for Private VM

## To Run  



## Notes 

- Notes. 

## Lessons Learned

- Digital Ocean auto-assigns a `public ip` with no option to turn off so access must be configured at firewall. 
- Terraform was hanging in GitHub Actions, ran locally and got the errors. Also was hanging due to not specifying token in plan command. 
- Also hanging and had to specify "-input=false \" in order for it to `stop waiting for an input` as I did not configure the multiple keys correctly
- leading and trailing `/` still haunt me ... 
- So rsync/scp had me running in circles. But again, took a step back, re-evaluated the approach and got it in a reasonable amount of time. 
- Whitespace after a newline `\` can cause issues 