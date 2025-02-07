export $(xargs < .env)

cd terraform

if [ ! -d .terraform ]; then
    terraform init
fi

terraform apply -var="proxmox_url=https://$PM_HOST:8006/api2/json" || exit 1

router_ip=$(terraform output -raw router)

echo $router_ip

cat > ../ansible/inventory.yml << EOF
---

router:
    hosts:
        $router_ip:
            ansible_user: deploy
            ansible_password: deploy
            ansible_port: 22
            ansible_connection: ssh
            ansible_ssh_common_args: '-o UserKnownHostsFile=/dev/null'
EOF

cd -

cd ansible

ansible-playbook -v lab.yml

cd -
