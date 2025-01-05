# Environment:
This project is dedicated to automating, and keep tracking of applied changes to following hosts:
1. Any desktop belongs to manar
2. The main cloud planning to run erc-20.

## Available Desktop Tasks:
### Jumphost:
Any host is reachable from anywhere using domain name **kaxtus.com**.

Available configurations are in `jumphost/vars/`.

**Run using your desired key in the configuration:**```
./ansible.sh -l desktop -t jumphost -e "user_pc_name=berlin"```

### Commands:
Adds commands aliases to `~/.zshrc` or `~/.bashrc`.

Available commands:
1. `publicip` to display public ip

**Run using**: ./ansible.sh -l desktop -t commands

### 1tbmount:
For the desktop in Berlin this mounts the 1tb free to `/mnt/1tb`.

## Available utility tasks
### add-main-ssh-host:
Adds entry to `~/.ssh/config` to connect to host defined in `inventory.ini`

**Run using**: ./ansible.sh -l desktop -t ssh-client

### Cloud:
1. Kaxtus: ``

## Infrastructre:
1. Kaxtus.com, kaxtus.de, quotomate, zaboub, reiddt, gulfrotables: godaddy: godaddy username 224581117
2. 