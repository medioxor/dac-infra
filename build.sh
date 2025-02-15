export $(xargs < .env)
cd packer
packer init config.pkr.hcl
{
    packer build -var-file variables.json ubuntu_server.json &
    packer build -var-file variables.json windows_11.json &
    packer build -var-file variables.json windows_server_2025.json &
    wait
}
cd -