#!/bin/bash

# Build Docker image
docker build -t ci-cd-app ./app

# Save EC2 IP from terraform
IP=$(terraform output -raw public_ip)

# Copy file to server
scp -o StrictHostKeyChecking=no -i key.pem app/index.html ubuntu@$IP:/home/ubuntu/

# SSH into server and run container
ssh -o StrictHostKeyChecking=no -i key.pem ubuntu@$IP << EOF
  sudo docker stop app  true
  sudo docker rm app  true
  sudo docker run -d -p 80:80 --name app ci-cd-app
EOF