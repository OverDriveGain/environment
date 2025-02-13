# Environment:

This project is dedicated to automating, and keep tracking of applied changes to following hosts:

1. Any desktop belongs to manar
2. The main cloud running on erc-20.

## Available Desktop Tasks:

### Jumphost:

Any host is reachable from anywhere using domain name **kaxtus.com**.

Available configurations are in `jumphost/vars/`.

1. **Run using your desired key in the configuration:**``` ./ansible.sh -l desktop -t jumphost -e "user_pc_name=berlin"```
2. **Run for music server port forwarding:**``` ./ansible.sh -l desktop -t jumphost -e "user_pc_name=berlin_music"```
### Commands:

Adds commands aliases to `~/.zshrc` or `~/.bashrc`.

Available commands:

1. `publicip` to display public ip

**Run using**: ./ansible.sh -l desktop -t commands

### 1tbmount:

For the desktop in Berlin this mounts the 1tb free to `/mnt/1tb`.

### ssh-client:

Adds entry to `~/.ssh/config` to connect to main cloud host defined in `inventory.ini`

**Run using**: ./ansible.sh -l desktop -t ssh-client

## Cloud:

### docker:

Install docker on host

**Run using**: `./ansible.sh -l cloud -t docker`

### bridge:

Creates a docker bridge named in `inventory.ini`

**Run using**: `./ansible.sh -l cloud -t bridge`

### nginx:

Creates an nginx with config as in template

**Run using**: `./ansible.sh -l cloud -t docker,nginx`
**See log**: `docker logs nginx-container`
### fresh:

For freshly installed ubuntu, installs zsh also.

**Run using**: `./ansible.sh -l cloud -t fresh`

### quotomatedb

Install postgresql, configures it, and can migrate db from old host to new host:

1. Setup: `./ansible.sh -l cloud -t quotomatedb:setup`
2. Configure: `./ansible.sh -l cloud -t quotomatedb:configure`
3. Migrate: `./ansible.sh -l cloud -t quotomatedb:migrate_db`

### websites
Install websites available in `/roles/websites/vars/main.yml`. Also, installs ssl. NGINX uses this for ssl serving.

There are two types of websites: Static as in kaxtus, and with nodejs server as in gaspi

1. **Run using**: `./ansible.sh -l cloud -t websites`

2. Or **Run using**: `./ansible.sh -l cloud -t websites -e "target_website=music"`

3. Adding new website: Use one of the available structures: gaspi, kaxtus -> copy file -> add config to vars -> create ssl using `./ansible.sh -l cloud -t websites:ssl` -> run nginx

quotomate is copy of gaspi
## Infrastructre:

1. Kaxtus.com, kaxtus.de, quotomate, zaboub, reiddt, gulfrotables: godaddy: godaddy username 224581117

# ToDo:

websites:
quotomate,
kaxtus.com
iphone,
gaspi,
aat,
sparescrew,
