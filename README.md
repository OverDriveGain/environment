# Environment:

This project is dedicated to automating, and keep tracking of applied changes to following hosts:

1. Any desktop belongs to manar
2. The main cloud running on erc-20.

## Available Desktop Tasks:

### Jumphost:

Any host is reachable from anywhere using domain name **kaxtus.com**.

Available configurations are in `jumphost/vars/`.

**Run using your desired key in the configuration:**``` ./ansible.sh -l desktop -t jumphost -e "user_pc_name=berlin"```

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

### fresh:

For freshly installed ubuntu, installs zsh also.

**Run using**: `./ansible.sh -l cloud -t fresh`

### quotomatedb

Install postgresql, configures it, and can migrate db from old host to new host:

1. Setup: `./ansible.sh -l cloud -t quotomatedb:setup`
2. Configure: `./ansible.sh -l cloud -t quotomatedb:configure`
3. Migrate: `./ansible.sh -l cloud -t quotomatedb:migrate_db`

### websites

Install websites available in `/roles/websites/vars/main.yml`. Also, installs ssl. NGINX uses this for ssl serving

**Run using**: `./ansible.sh -l cloud -t websites`

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
