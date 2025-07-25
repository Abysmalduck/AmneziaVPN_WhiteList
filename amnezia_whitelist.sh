#!/bin/bash

echo "Amnesia VPN white list v0.3"

PROCESSES="vesktop discord vesktop.bin firefox electron app.asar Discord"

# Creating cgroup
mkdir /sys/fs/cgroup/amnesia_whitelist/
mkdir -p /etc/iproute2
touch /etc/iproute2/rt_tables
echo "200 vpn" >> /etc/iproute2/rt_tables

while true
do
    while true
    do

        if ip a | grep -q tun2
        then
            break
        else
            echo "No tun2!"
        fi

        sleep 2
    done

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
    ip route add default via 10.33.0.2 dev tun2 table vpn 2> /dev/null
    ip rule add fwmark 171 table vpn 2> /dev/null

    proc_array=(${PROCESSES})

    for proc in ${proc_array[@]}; do
        pids=$(pidof $proc)
        pids_array=(${pids})
        for el in ${pids_array[@]}; do
            echo $el >> /sys/fs/cgroup/amnesia_whitelist/cgroup.procs
        done
    done
    sleep 1
done
