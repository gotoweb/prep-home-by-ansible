#cloud-boothook
#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo yum -y install git
curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum -y install nodejs
