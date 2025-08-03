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

For the desktop in Berlin this mounts the 1tb free to `/mnt/tb`.

**Run using**: ./ansible.sh -l desktop -t 1tbmount

### ssh-client:

Adds entry to `~/.ssh/config` to connect to main cloud host defined in `inventory.ini`

**Run using**: ./ansible.sh -l desktop -t ssh-client

### musdowlow:

Runs a Docker container for YouTube music downloads. Downloads are saved to the music directory.

**Run using**: ./ansible.sh -l desktop -t musdowlow

## Cloud:

### docker:

Install docker on host

**Run using**: `./ansible.sh -l cloud -t docker`

### bridge:

Creates a docker bridge named in `inventory.ini`

**Run using**: `./ansible.sh -l cloud -t bridge`

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
2. **Single website**: `./ansible.sh -l cloud -t websites -e "target_website=music"`
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