#!/bin/bash

# Update the package index
sudo apt-get update

# Install Apache2 (httpd)
sudo apt-get install -y apache2

# Enable Apache2 to start on boot
sudo systemctl enable apache2

# Start Apache2 service
sudo systemctl start apache2

# Print the status of Apache2 service
sudo systemctl status apache2
# Create a simple HTML file to serve as the welcome page
echo "<html><body><h1>Welcome to the web server!</h1></body></html>" | sudo tee /var/www/html/index.html
# Get the server's IP address
SERVER_IP=$(hostname -I | awk '{print $1}')

# Create a simple HTML file to serve as the welcome page with the server's IP address
echo "<html><body><h1>Welcome to the web server!</h1><p>Server IP: $SERVER_IP</p></body></html>" | sudo tee /var/www/html/index.html