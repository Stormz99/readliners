#!/bin/bash
set -e
LOG_FILE="/var/log/user-data.log"
exec > >(tee -a $LOG_FILE) 2>&1

echo "=== EC2 setup starting at $(date) ==="

if command -v apt &> /dev/null; then
    echo "Updating APT packages..."
    sudo apt-get update -y
    sudo apt-get upgrade -y
elif command -v yum &> /dev/null; then
    echo "Updating YUM packages..."
    sudo yum update -y
fi

echo "Installing essential packages..."
if command -v apt &> /dev/null; then
    sudo apt-get install -y nginx git curl unzip
elif command -v yum &> /dev/null; then
    sudo yum install -y nginx git curl unzip
fi

echo "Starting NGINX..."
sudo systemctl enable nginx
sudo systemctl start nginx

echo "<h1>Terraform EC2 Setup Successful</h1>" | sudo tee /var/www/html/index.html

echo "=== EC2 setup completed at $(date) ==="
