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

4. Or without SSL **Run using**: `./ansible.sh -l cloud -t websites -e "target_website=gaspi" -e "nossl=true"`

quotomate is copy of gaspi

### websites ssl only
Only installs ssl certificate for websites available in `/roles/websites/vars/main.yml`
```angular2html
./ansible.sh -l cloud -t websites:ssl
```

### House
#### Configure jump host:
1. **Website** necessary for compliance with other modules: `./ansible.sh -l cloud -t websites -e "target_website=house"`
2. If SSL did not run in previous step then run ssl refer **websites ssl only** section.
3. **Nginx** to map `house.kaxtus.com` to the raspberry pi: `./ansible.sh -l cloud -t nginx`
#### Configure home assistant
1. Install home assistant and confirm that its working by accessing GUI on `192.168.0.x:8123`
2. Enable terminal access from add-on, and preferably confirm by enabling ssh access without `gui`: enable advanced mode, enable remote access, etc
3. in file `/config/configuration.yaml` add following, the ip `172.30.33.0` might need to change but its for the docker, the ip 192.168.0.176 is used for autossh later, its the ip with which the gui can be accessed as well as the ssh of the homeassistant: 
```angular2html:
http:
    use_x_forwarded_for: true
    trusted_proxies:
        - 172.30.33.0
        - 192.168.0.176
```
4. restart: `ha core restart`
5. Install addon from `https://github.com/ThomDietrich/home-assistant-addons` by adding this repository to the add one store third party repositories
6. Configure as follow: 
```angular2html
hostname: kaxtus.com
port: 22
username: ubuntu
remote_ip_address: 127.0.0.1
remote_port: 8123
local_ip_address: 192.168.0.176
local_port: 8123
remote_forwarding: leave empty
```
8. Log with: `ha core logs`, and on jumpserver cat `sudo tail -f /var/log/auth.log`
9. If it doesn't work test with raw ssh forwarding from homeassistant with command: `ssh -R 8123:192.168.0.176:8123 ubuntu@kaxtus.com`
10. Possibile fixes: `ha core logs` -> find which ip address its complaining about replace this ip address to the truested_proxies

### openvpn:
Is not stable, use the script open-vpn-install.sh. If two public ip addresses are there, set in file `/etc/openvpn/server.conf`:
```angular2html
local 172.31.46.166 <--------- This is private ip of the interface of the required public ip
```

## Infrastructre:
1. Kaxtus.com, kaxtus.de, quotomate, zaboub, reiddt, gulfrotables: godaddy: godaddy username 224581117
2. Others: username 64879667

### Windows pc:
1. Thinkcentre with RDP. Local ip 192.168.0.166
2. Port forwarding with bitvie s2c: ``
# ToDo:
websites:
quotomate,
kaxtus.com
iphone,
gaspi,
aat,
sparescrew,
