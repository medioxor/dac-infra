export $(xargs < .env)
cd terraform

terraform destroy -var="proxmox_url=https://$PM_HOST:8006/api2/json"

cd -