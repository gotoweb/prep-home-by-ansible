#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

curl -o loop.sh https://static-file-server-for-devops-bootcamp.s3.ap-northeast-2.amazonaws.com/loop.sh
chmod +x loop.sh
curl -sL https://static-file-server-for-devops-bootcamp.s3.ap-northeast-2.amazonaws.com/users.csv | sudo xargs ./loop.sh
