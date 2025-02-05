

# Set up

## Ubuntu
- Install Terraform
    ```
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt update
    sudo apt install -y terraform packer python3-pip
    pip3 install ansible pywinrm –user
    ```