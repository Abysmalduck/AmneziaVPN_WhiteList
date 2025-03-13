#!/bin/bash

echo "Amnesia VPN white list v0.2"

while true
do
    echo checking tun2...

    if ip a | grep -q tun2
    then
        echo "tun2 interface found. Starting whitelist!"
        break
    else
        echo "No tun2!"
    fi

    sleep 1
done

# Creating cgroup
mkdir /sys/fs/cgroup/amnesia_whitelist/ 

# Set up iptables
iptables -t mangle -F 
iptables -t mangle -A OUTPUT -m cgroup --path "amnesia_whitelist" -j MARK --set-mark 171
iptables -t mangle -A INPUT -m cgroup --path "amnesia_whitelist" -j MARK --set-mark 171

# Deleting existing VPN routes
ip route del "0.0.0.0/1" 2>/dev/null
ip route del "1.0.0.1" 2>/dev/null
ip route del "1.1.1.1" 2>/dev/null
ip route del "128.0.0.0/1" 2>/dev/null
ip route del "10.33.0.0/24" 2>/dev/null 

# Set up vpn table
mkdir -p /etc/iproute2 
echo "200 vpn" >> /etc/iproute2/rt_tables
ip route add default via 10.33.0.2 dev tun2 table vpn 
ip rule add fwmark 171 table vpn

echo "Starting to poll processes"

PROCESSES="vesktop discord vesktop.bin firefox electron app.asar"
proc_array=(${PROCESSES})

while true
do
    for proc in ${proc_array[@]}; do
        pids=$(pidof $proc)
        pids_array=(${pids})
        for el in ${pids_array[@]}; do
            echo $el >> /sys/fs/cgroup/amnesia_whitelist/cgroup.procs
        done
    done
    sleep 1
done