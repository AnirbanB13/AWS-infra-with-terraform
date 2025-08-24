#!/bin/bash

# Update package lists
sudo apt update

# Install Apache2
sudo apt install apache2 -y

# Fetch instance ID and write to index.html
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
echo "Hello, World from server one $instance_id!" | sudo tee /var/www/html/index.html

# Enable and start Apache2 service
sudo systemctl enable apache2
sudo systemctl start apache2
