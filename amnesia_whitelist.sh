#!/bin/bash

echo "Amnesia VPN white list v0.1"

while true
do
    echo checking tun2...

    if ip a | grep -q tun2
    then
        echo tun2 interface found starting whitelist!
        break;
    else
        echo no tun2!
    fi

    sleep 1
done

mkdir /sys/fs/cgroup/amnesia_whitelist/ #Creating cgroup

iptables -t mangle -F #mark all packet that located in cgroup
iptables -t mangle -A OUTPUT -m cgroup --path "amnesia_whitelist" -j MARK --set-mark 171
iptables -t mangle -A INPUT -m cgroup --path "amnesia_whitelist" -j MARK --set-mark 171

ip route del "0.0.0.0/1" # unroute existing VPN connection
ip route del "1.0.0.1"
ip route del "1.1.1.1"
ip route del "128.0.0.0/1"
ip route del "10.33.0.0/24" #is this adress for everyone?

mkdir /etc/iproute2 # route our applications to VPN
echo "200 vpn" |  tee -a /etc/iproute2/rt_tables
ip route add default via 10.33.0.2 dev tun2 table vpn
ip rule add fwmark 171 table vpn

echo "Staring to poll processes"

PROCESSES="vesktop discord vesktop.bin firefox electron app.asar"

proc_array=(${PROCESSES//;/ })

#adding applications to cgroup
while true
do
    for proc in ${proc_array[@]}; do
        pids=$(pidof $proc)
        pids_array=(${pids//;/ })
        for el in ${pids_array[@]}; do
            echo ${el} |  tee -a /sys/fs/cgroup/amnesia_whitelist/cgroup.procs > /dev/null
        done
    done
    sleep 1
done
