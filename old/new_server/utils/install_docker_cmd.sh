#!/bin/bash

# Update apt-get package list
sudo apt-get update
if [ $? -ne 0 ]; then
    echo "Error: Failed to update package list. Please check your repository configuration."
    exit 1
fi

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && [[ $VERSION_CODENAME=='wilma' ]] && echo noble || echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Add Docker GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
if [ $? -ne 0 ]; then
    echo "Error: Failed to add Docker GPG key."
    exit 1
fi

# Add Docker repository
sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
if [ $? -ne 0 ]; then
    echo "Error: Failed to add Docker repository."
    exit 1
fi

# Update apt-get again after adding Docker repository
sudo apt-get update
if [ $? -ne 0 ]; then
    echo "Error: Failed to update package list after adding Docker repository."
    exit 1
fi

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
if [ $? -ne 0 ]; then
    echo "Error: Failed to install Docker."
    exit 1
fi

echo "Docker installation completed successfully!"
