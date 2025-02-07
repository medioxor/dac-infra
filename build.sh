cd packer
dotenv -e ../.env packer build -var-file variables.json ubuntu_server.json
cd -