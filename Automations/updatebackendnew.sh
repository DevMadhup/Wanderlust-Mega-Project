#!/bin/bash

# Set the Instance ID and path to the .env file
INSTANCE_ID="i-0ee177c8f3cdd7103"

# Retrieve the public IP address of the specified EC2 instance
ipv4_address=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

# Initializing variables
file_to_find="../backend/.env.docker"
alreadyUpdate=$(sed -n "4p" ../backend/.env.docker)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Use curl to fetch the public IPv4 address from the metadata service

echo -e " ${GREEN}System Public Ipv4 address ${NC} : ${ipv4_address}"

if [[ "${alreadyUpdate}" == "FRONTEND_URL=\"http://${ipv4_address}:5173\"" ]]
then
        echo -e "${YELLOW}${file_to_find} file is already updated to the current host's Ipv4 ${NC}"
else
        if [ -f ${file_to_find} ]
        then
                echo -e "${GREEN}${file_to_find}${NC} found.."
                echo -e "${YELLOW}Configuring env variables in ${NC} ${file_to_find}"
                sleep 7s;
                sed -i -e "s|FRONTEND_URL.*|FRONTEND_URL=\"http://${ipv4_address}:5173\"|g" ${file_to_find}
                echo -e "${GREEN}env variables configured..${NC}"
        else
                echo -e "${RED}ERROR : File not found..${NC}"
        fi
fi
