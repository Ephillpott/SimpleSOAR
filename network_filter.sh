#!/bin/bash

# ITAR country codes
ITAR_COUNTRIES=("AF" "AO" "BY" "CN" "CU" "CY" "HT" "IQ" "IR" "KP" "LR" "LY" "NG" "RW" "SO" "SD" "SY" "VN" "YE" "ZW")

# Log file to monitor for network connections
LOG_FILE="/var/log/syslog"

# Log file for blocked IPs
BLOCK_LOG="/var/log/blocked_ips.log"

# Function to block an IP address
block_ip() {
  IP_ADDRESS=$1
  iptables -A INPUT -s $IP_ADDRESS -j DROP
  echo "$(date) - Blocked IP address: $IP_ADDRESS" >> $BLOCK_LOG 
  echo "Blocked IP address: $IP_ADDRESS"
}

# Monitor the log file for connections
tail -f $LOG_FILE | while read LINE; do
  # Extract the IP address (you might need to adjust this based on your log format)
  IP_ADDRESS=$(echo $LINE | awk '{print $5}') 

  # Get the country code for the IP address using GeoIP
  COUNTRY_CODE=$(geoiplookup $IP_ADDRESS | awk '{print $4}' | cut -d ',' -f 1)

  # Check if the country code is in the ITAR list
  if [[ " ${ITAR_COUNTRIES[@]} " =~ " ${COUNTRY_CODE} " ]]; then 
    block_ip $IP_ADDRESS
  fi
done
