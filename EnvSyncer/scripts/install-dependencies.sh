#!/bin/bash
# Install script for required dependencies

chmod +x install_dependencies.sh

echo "Updating system..."
sudo apt-get update

echo "Installing AWS CLI..."
sudo apt-get install -y awscli

echo "Installing MySQL Client..."
sudo apt-get install -y mysql-client

echo "Installing Pipe Viewer (pv)..."
sudo apt-get install -y pv

echo "Installing gzip..."
sudo apt-get install -y gzip

echo "All necessary dependencies have been installed."
