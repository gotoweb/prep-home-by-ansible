#!/bin/bash

for var in "$@"
do
  # mkdir /home/ubuntu/$i
  echo "$var"
  adduser $var
  mkdir -p /home/$var/.ssh
  chmod 700 /home/$var/.ssh
  echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtYD7tut/pQx6KU+EIaHJdQmLzh+TfuZeqciWoC1t+N8wUA1ihQvomZp+ZTyR/BCaf1BQOQ6Hedo2L6DwBqXiip5D9AQf9gyliKNPnuNWmLLhSpDzZLq7EWpB7vdH2KD9vXq4xay8zvdIK6/84C0w9fyTZolI3sEwPNGyQ2DyjvU1w3ZW1HCzEtBzXpb7dzwexIOltNp7lF9HJ9HfMSfuCOkWmFNddP3dcCCIKoTy7VMIGN4ZgGzyxG/XSVmYEKsL1oM14Qhc5jfJt9ZFL/bQG90IxBxvp8Rtl5Wiyp283ixvU75MliWO0tIl/T7LJy3l9b9rTZ2b884JnMILsoenT gotoweb@ip-10-0-101-73.ap-northeast-2.compute.internal" > /home/$var/.ssh/authorized_keys
  chmod 600 /home/$var/.ssh/authorized_keys
  chown $var:$var /home/$var
  chown $var:$var /home/$var/.ssh
  chown $var:$var /home/$var/.ssh/authorized_keys
done