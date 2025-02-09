cd packer
dotenv -e ../.env packer build -var-file variables.json ubuntu_server.json
dotenv -e ../.env packer build -var-file variables.json windows_11.json
cd -