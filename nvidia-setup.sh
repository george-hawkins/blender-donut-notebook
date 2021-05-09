#!/bin/bash -e

# Instructions:
# First make sure there isn't a later driver version than /usr/share/doc/nvidia-driver-460.
# Then run this script - it's constructed from the README in that directory.
# Running the script isn't enough - things only started working once I rebooted the system.

echo 'options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp' | sudo tee /etc/modprobe.d/nvidia-power-management.conf > /dev/null

cd /usr/share/doc/nvidia-driver-460

sudo install nvidia-suspend.service /etc/systemd/system
sudo install nvidia-hibernate.service /etc/systemd/system
sudo install nvidia-resume.service /etc/systemd/system
sudo install nvidia /lib/systemd/system-sleep
sudo install nvidia-sleep.sh /usr/bin

sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service
