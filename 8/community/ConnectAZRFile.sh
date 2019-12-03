#!/usr/bin/env bash

sudo mkdir /mnt/totalhp2welrs
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/totalhp2welrs.cred" ]; then
    sudo bash -c 'echo "username=totalhp2welrs" >> /etc/smbcredentials/totalhp2welrs.cred'
    sudo bash -c 'echo "password=C0xP848pOZVZAZ1dUqMfe8kir4W/IQl2IDL3LgWFUKlk7K/bvMNlKKoC4O7ZhNEdt5GwvpXoOZFSr6wV6Uiu+w==" >> /etc/smbcredentials/totalhp2welrs.cred'
fi
sudo chmod 600 /etc/smbcredentials/totalhp2welrs.cred

sudo bash -c 'echo "//totalhp2welrs.file.core.windows.net/sonarqube /mnt/totalhp2welrs cifs nofail,vers=3.0,credentials=/etc/smbcredentials/totalhp2welrs.cred,dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab'
sudo mount -t cifs //totalhp2welrs.file.core.windows.net/sonarqube /mnt/totalhp2welrs -o vers=3.0,credentials=/etc/smbcredentials/totalhp2welrs.cred,dir_mode=0777,file_mode=0777,serverino
