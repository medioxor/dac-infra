export $(xargs < .env)

cd terraform

if [ ! -d .terraform ]; then
    terraform init
fi

if ! terraform apply -var="proxmox_url=https://$PM_HOST:8006/api2/json"; then
    exit 1
fi

attempt=0
while true; do
    router_ip=$(terraform output -raw router)
    dc_ip=$(terraform output -raw dc)
    wef_ip=$(terraform output -raw wef)
    workstation1_ip=$(terraform output -raw workstation1)

    if [ -z "$router_ip" ] || [ -z "$dc_ip" ] || [ -z "$workstation1_ip" ] || [ -z "$wef_ip" ]; then
        echo "One or more terraform outputs are empty!"
        attempt=$((attempt + 1))
        if [ "$attempt" -gt 5 ]; then
            echo "Failed to get terraform outputs after 5 attempts."
            exit 1
        fi
        echo "Retrying... (attempt $attempt)"
        terraform refresh -var="proxmox_url=https://$PM_HOST:8006/api2/json";
        sleep 5
    else
        break
    fi
done

cat > ../ansible/inventory.yml << EOF
---

router:
    hosts:
        $router_ip

dc:
    hosts:
        $dc_ip

wef:
    hosts:
        $wef_ip

windows_workstations:
    hosts:
        $workstation1_ip
EOF

cd -

sleep 30

cd ansible
ansible-playbook -v lab.yml --tags router &
wait
ansible-playbook -v lab.yml --tags dc &
wait
ansible-playbook -v lab.yml --tags wef &
wait
ansible-playbook -v lab.yml --tags windows_workstations &
wait
ansible-playbook -v lab.yml --tags final_touches &
wait
ansible-playbook -v lab.yml --tags reboot &
wait

cd -
