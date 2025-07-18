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

### quotomate

Install postgresql, configures it, and can migrate db from old host to new host:

1. Setup DB: `./ansible.sh -l cloud -t quotomate:setup_db`
2. Configure DB: `./ansible.sh -l cloud -t quotomate:configure_db`
3. Migrate DB: `./ansible.sh -l cloud -t quotomate:migrate_db`
4. Start PN search engine API: `./ansible.sh -l cloud -t quotomate:pn_search_engine_api`

### websites
Install websites available in `/roles/websites/vars/main.yml`. Also, installs ssl. NGINX uses this for ssl serving.

There are two types of websites: Static as in kaxtus, and with nodejs server as in gaspi

1. **Run using**: `./ansible.sh -l cloud -t websites`

2. Or **Run using**: `./ansible.sh -l cloud -t websites -e "target_website=music"`

3. Adding new website: Use one of the available structures: gaspi, kaxtus -> copy file -> add config to vars -> create ssl using `./ansible.sh -l cloud -t websites:ssl` ->  run nginx ansible with `./ansible.sh -l cloud -t nginx`

4. Or without SSL **Run using**: `./ansible.sh -l cloud -t websites -e "target_website=gaspi" -e "nossl=true"`

quotomate is copy of gaspi

### websites ssl only
Only installs ssl certificate for websites available in `/roles/websites/vars/main.yml`
```angular2html
./ansible.sh -l cloud -t websites:ssl
```
In host the directory of ssl certificates of nginx is in '/opt/nginx/ssl/'
And is copied from the letsencrypt default directory

Debug. Sometimes the certificates don't renew to do this manually
```js
docker stop nginx-container
sudo certbot certonly --standalone \             
  --email admin@calgaryexpedite.com \ 
  -d calgaryexpedite.com -d www.calgaryexpedite.com \
  --agree-tos \
  --non-interactive \
  --debug
docker start nginx-container```

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
11. ssh into home assistance: ssh root@192.168.0.176 -p 10666 pass: manarmama3
### openvpn:
Is not stable, use the script open-vpn-install.sh. If two public ip addresses are there, set in file `/etc/openvpn/server.conf`:
```angular2html
local 172.31.46.166 <--------- This is private ip of the interface of the required public ip
```

## Infrastructre:
1. Kaxtus.com, kaxtus.de, quotomate, zaboub, reiddt, gulfrotables: godaddy: godaddy username 224581117
2. Others: username 64879667

### Windows pc:
<<<<<<< HEAD
1. Thinkcentre with RDP windows feature. Test locally if ok proceed
2. Set Local static ip 192.168.0.166. Test locally if ok proceed
2. Port forwarding from host to local with bitvie -> open tab s2c: `` 
3. for bitvie create a profile then a shortcut "C:\Program Files (x86)\Bitvise SSH Client\BvSsh.exe" -profile="C:\Users\manar\Documents\remotedesk.tlp" -loginOnStartup 
4. Add above file to win+r shell:startup
5. add autologin on windows by editing registery win+r regedit: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon
6. Disable sleep and hibernation

=======
1. Thinkcentre with RDP. Local ip 192.168.0.166
2. Port forwarding with bitvie using tab s2c
3. Use ssh keys keys
4. Add to start up, beware to add to start up of the correct user that starts the pc from the local monitor: https://superuser.com/questions/1353398/how-can-i-set-in-the-bitvise-ssh-client-the-tunnel-automatic-connect-if-open-wi
5. Remote desktop using the windows feature
6. 
## Linux xrdp
1. Connect using: xfreerdp /v:kaxtus.com:3389 /u:manar /p:manarmama3 +clipboard +home-drive +fonts +window-drag /sound:sys:alsa /microphone:sys:alsa /compression-level:2 /network:auto /dynamic-resolution /f /log-level:WARN
2. ctrl + alt + enter exit fullscreen
>>>>>>> 74a252d (Restructure)
# ToDo:
websites:
quotomate,
kaxtus.com
iphone,
gaspi,
aat,
sparescrew,

# Debug:

1. fatal: [kaxtus]: FAILED! => {"changed": false, "gid": 101, "group": "messagebus", "mode": "0755", "msg": "chown failed: [Errno 1] Operation not permitted: b'/home/ubuntu/nginx-dist-websites'", "owner": "messagebus", "path": "/home/ubuntu/nginx-dist-websites", "size": 4096, "state": "directory", "uid": 101}
do: sudo chown -R ubuntu:ubuntu nginx-dist-websites
2. nginx container not starting: docker logs nginx-container
3. nginx container config: sudo cat /opt/nginx/conf/nginx.conf
4. nginx container errors: docker exec -it nginx-container tail -f /var/log/nginx/error.log