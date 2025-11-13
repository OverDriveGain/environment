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

**Run using**: ./ansible.sh -l desktop -t 1tbmount

### ssh-client:

Adds entry to `~/.ssh/config` to connect to main cloud host defined in `inventory.ini`

**Run using**: `./ansible.sh -l desktop -t ssh-client`

### musdowlow:

Runs a Docker container for YouTube music downloads. Downloads are saved to the music directory.

**Run using**: ./ansible.sh -l desktop -t musdowlow

## Cloud:

### docker:

Install docker on host

**Run using**: `./ansible.sh -l cloud -t docker`

### bridge:

Creates a docker bridge named in `inventory.ini`

**Run using**: `./ansible.sh -l cloud -t bridge` #ToDo see if removed

### nginx:

Creates an nginx with modular configuration templates for different website types.

**Run for all websites**: `./ansible.sh -l cloud -t nginx`
**Run for single website**: `./ansible.sh -l cloud -t nginx -e "target_website=quotomate"`
**See logs**: `docker logs nginx-container`

**Website Templates Available:**
- `static_site` - For static HTML/CSS/JS sites (like kaxtus.com)
- `node_app` - For Node.js applications (like gaspi.aero)
- `node_app_with_static` - For Node.js apps with static subdomains (like quotomate)
- `proxy_app` - For generic proxy applications with WebSocket support (like n8n, house)

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

Install websites available in `/roles/websites/vars/main.yml`. Automatically installs SSL certificates. NGINX uses this for SSL serving.

**Supported Website Types:**
- **Static sites**: kaxtus.com, reiddt.com, rieddt.com
- **Node.js apps**: gaspi.aero, quotomate.com, calgaryexpedite.com
- **Proxy apps**: music.kaxtus.com, house.zaboub.com, n8n.kaxtus.com, analytics.kaxtus.com

**Commands:**
1. **All websites**: `./ansible.sh -l cloud -t websites`
2. **Single website**: `./ansible.sh -l cloud -t websites -e "target_website=n8n"`
3. **Without SSL**: `./ansible.sh -l cloud -t websites -e "target_website=gaspi" -e "nossl=true"`
4. **SSL only**: `./ansible.sh -l cloud -t websites -e "onlyssl=true"`

**Adding new website:**
1. Copy existing task from `/roles/websites/tasks/websites/`
2. Add configuration to `/roles/websites/vars/main.yml`
3. Choose appropriate template type in config
4. Run: `./ansible.sh -l cloud -t websites -e "target_website=newsite"`
5. Update nginx: `./ansible.sh -l cloud -t nginx -e "target_website=newsite"`

**Fast nginx config updates:**
- Single website: `./ansible.sh -l cloud -t nginx -e "target_website=quotomate"` (uses `nginx -s reload`)
- All websites: `./ansible.sh -l cloud -t nginx` (full container restart)

### websites ssl only

Only installs SSL certificates for websites available in `/roles/websites/vars/main.yml`

```bash
./ansible.sh -l cloud -t websites:ssl
```

In host the directory of ssl certificates of nginx is in '/opt/nginx/ssl/'
And is copied from the letsencrypt default directory

Debug. Sometimes the certificates don't renew to do this manually:
```bash
docker stop nginx-container
sudo certbot certonly --standalone \             
  --email admin@calgaryexpedite.com \ 
  -d calgaryexpedite.com -d www.calgaryexpedite.com \
  --agree-tos \
  --non-interactive \
  --debug
docker start nginx-container
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
```yaml
http:
    use_x_forwarded_for: true
    trusted_proxies:
        - 172.30.33.0
        - 192.168.0.176
```
4. restart: `ha core restart`
5. Install addon from `https://github.com/ThomDietrich/home-assistant-addons` by adding this repository to the add one store third party repositories
6. Configure as follow:
```yaml
hostname: kaxtus.com
port: 22
username: ubuntu
remote_ip_address: 127.0.0.1
remote_port: 8123
local_ip_address: 192.168.0.176
local_port: 8123
remote_forwarding: leave empty
```
7. Log with: `ha core logs`, and on jumpserver cat `sudo tail -f /var/log/auth.log`
8. If it doesn't work test with raw ssh forwarding from homeassistant with command: `ssh -R 8123:192.168.0.176:8123 ubuntu@kaxtus.com`
9. Possible fixes: `ha core logs` -> find which ip address its complaining about replace this ip address to the trusted_proxies
10. ssh into home assistant: ssh root@192.168.0.176 -p 10666 pass: manarmama3

### openvpn:

Is not stable, use the script open-vpn-install.sh. If two public ip addresses are there, set in file `/etc/openvpn/server.conf`:
```
local 172.31.46.166 <--------- This is private ip of the interface of the required public ip
```

## Infrastructure:

1. Kaxtus.com, kaxtus.de, quotomate, zaboub, reiddt, gulfrotables: godaddy: godaddy username 224581117
2. Others: username 64879667

### Windows pc:

#### xrdp:
1. Thinkcentre with RDP windows feature. Test locally if ok proceed
2. Set Local static ip 192.168.0.166. Test locally if ok proceed
3. Skip next s2c configuration if loaded profile in this repo `/data/xrdp_portforwarding_and_ssh_client_windows.tlp`
4. Port forwarding from host to local with bitvise -> open tab s2c
5. for bitvise create a profile then a shortcut "C:\Program Files (x86)\Bitvise SSH Client\BvSsh.exe" -profile="C:\Users\manar\Documents\remotedesk.tlp" -loginOnStartup
6. Add above file to win+r shell:startup
7. add autologin on windows by editing registry win+r regedit: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon
8. Disable sleep and hibernation

#### SSH remote access:
1. install bitvise ssh server
2. in easy settings -> windows account -> check allow login from any windows account

## Linux xrdp

1. Connect using: `xfreerdp /v:kaxtus.com:3389 /u:manar /p:manarmama3 +clipboard +home-drive +fonts +window-drag /sound:sys:alsa /microphone:sys:alsa /compression-level:2 /network:auto /dynamic-resolution /f /log-level:WARN`
2. ctrl + alt + enter exit fullscreen

# Debug:

1. fatal: [kaxtus]: FAILED! => {"changed": false, "gid": 101, "group": "messagebus", "mode": "0755", "msg": "chown failed: [Errno 1] Operation not permitted: b'/home/ubuntu/nginx-dist-websites'", "owner": "messagebus", "path": "/home/ubuntu/nginx-dist-websites", "size": 4096, "state": "directory", "uid": 101}

   **Solution**: `sudo chown -R ubuntu:ubuntu nginx-dist-websites`

2. nginx container not starting: `docker logs nginx-container`

3. nginx container config: `sudo cat /opt/nginx/conf/nginx.conf`

4. nginx container errors: `docker exec -it nginx-container tail -f /var/log/nginx/error.log`