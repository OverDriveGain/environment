# Environment:
This project is dedicated to automating, and keep tracking of applied changes to following hosts:
1. Any desktop belongs to manar
2. The main cloud planning to run erc-20.

## Available Tasks:
### Desktop:
Use limit to skip gather facts for other playbook in same file
#### Jumphost:
Any host is reachable from anywhere using domain name ***kaxtus.com***.
Available configurations are in `jumphost/vars/`.
Run using your desired key in the configuration by ``
`ansible-playbook -i inventory.ini playbook.yml --limit desktop --tags jumphost -e "host_name=new_value"`
2. 

### Cloud:
1. Kaxtus: ``

## Infrastructre:
1. Kaxtus.com, kaxtus.de, quotomate, zaboub, reiddt, gulfrotables: godaddy: godaddy username 224581117
2. 