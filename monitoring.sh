#!/bin/bash

# Architecture and Kernel Version
arch_kernel=$(uname -a)

# Number of Physical and Virtual Processors
physical_processors=$(lscpu | grep "Socket(s)" | awk '{print $2}')
virtual_processors=$(nproc)

# Memory Information
mem_info=$(free -m)
used_ram=$(echo "$mem_info" | awk '/^Mem:/{print $3}')
total_ram=$(echo "$mem_info" | awk '/^Mem:/{print $2}')
ram_utilization=$(echo "scale=2; $used_ram / $total_ram * 100" | bc)

# Disk Information
disk_info=$(df -h /)
used_disk=$(echo "$disk_info" | awk '/\//{print $3}')
total_disk=$(echo "$disk_info" | awk '/\//{print $2}')
disk_utilization=$(echo "$disk_info" | awk '/\//{print $5}' | cut -d'%' -f1)

# CPU Utilization
cpu_utilization=$(mpstat | grep "all" | awk '{printf "%.2f", 100 -$NF}')
# Last Reboot Time
last_reboot=$(uptime -s)

# LVM Status
lvmt=$(lsblk | grep "lvm" | wc -l)
lvm_status=$(if [ $lvmt -eq 0 ]; then echo no; else echo yes; fi)

# Number of Active Connections
active_connections=$(netstat -an | grep -c ESTABLISHED)

# Number of Users
num_users=$(who | wc -l)

# IPv4 Address and MAC Address
ip_address=$(hostname -I | awk '{print $1}')
mac_address=$(ip a | awk '/ether/{print $2}')

# Number of sudo Commands Executed
sudo_commands_executed=$(grep "COMMAND" "/var/log/sudo/log.log" | wc -l)

# Broadcast message using wall
wall "Broadcast message from root@$(hostname) ($(tty)) ($(date +"%a %b %d %T %Y")):
#Architecture: $arch_kernel
#CPU physical : $physical_processors
#vCPU : $virtual_processors
#Memory Usage: $used_ram/$total_ram MB ($ram_utilization%)
#Disk Usage: $used_disk/$total_disk ($disk_utilization%)
#CPU load: $cpu_utilization%
#Last boot: $last_reboot
#LVM use: $lvm_status
#Connections TCP : $active_connections ESTABLISHED
#User log: $num_users
#Network: IP $ip_address ($mac_address)
#Sudo : $sudo_commands_executed cmd
"