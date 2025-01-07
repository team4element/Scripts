#!/bin/bash

#default password for the roborio is ""

#Don't want to keep getting prompted for the password?
#Run these two simple commands in your git bash termial that doctors hate!
#ssh-keygen -t rsa -b 4096 -C "your_team_number" (hit enter when prompted)
#ssh-copy-id username@remote_host 

RED="\033[0;31m"
GREEN="\033[1;32m" 
NC="\033[0m"

function usage {
    echo -e "\nUsage: $0 {options}\n" \
            "\nOptions:\n" \
            "   -t set the ip to roboRIO-(your_team_numer)-frc.local  | default is roboRIO-4-frc.local\n" \
            "   -b use the default ip when connectd via usb           | usb ip is: 172.22.11.2        \n" \
            "   -u change the username                                | default is admin              \n" \
            "   -h print this menu and quit                                                           \n"
    exit 0
}

function print_error {
    echo -e "${RED}Error:${NC} $1"
}

function print_success {
    echo -e "${GREEN}Success:${NC} $1" 
}

ip=roboRIO-4-frc.local
usb_ip=172.22.11.2
username="admin" 
autos_dir="/home/lvuser/deploy"

while getopts "t:u::bh" opt; do
    case "${opt}" in
        t) ip=ip=roboRIO-${OPTARG}-frc.local;;
        b) ip="$usb_ip";;
        u) username=${OPTARG};;
        h) usage;;
        ?) usage;;
    esac
done
shift $((OPTIND-1))

# shellcheck disable=SC2029
if ssh "$username@$ip" "rm -rf $autos_dir"; then
    print_success "Old autos deleted"
else
    print_error "Could not delete old autos"
fi