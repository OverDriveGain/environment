# Overview
This project is dedicated to automating, and keep tracking of applied changes to following hosts:
1. Desktop in berlin
2. Cloud in amazon

# Tasks:
## Berlin desktop:
1. Jump host: set host_name as in config for vars
```angular2html
ansible-playbook playbooks/desktop/jump.yaml --ask-become-pass -vvv -e "host_name=desktop_berlin"
```
## Cloud in amazon:
1. Kaxtus website
2. IPhone storage service
3. Quotomate