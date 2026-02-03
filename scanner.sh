#!/bin/bash

# ANSI Color Codes
GREEN='\033[0;32m'
BOLD_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' 

# Function for detailed IP scan
detailed_scan() {
    local IP=$1
    local PROVIDER_NAME=$2
    TARGET="google.com"
    
    # Get only the numeric value of latency
    AVG_LATENCY=$(ping -c 1 -W 1 "$IP" 2>/dev/null | tail -1 | awk -F '/' '{print $5}')
    
    if [ -z "$AVG_LATENCY" ]; then
        LATENCY_STR="TIMEOUT"
    else
        # Correctly format with a single 'ms'
        LATENCY_STR="${AVG_LATENCY} ms"
    fi

    RESOLVED_IP=$(drill @$IP $TARGET 2>/dev/null | grep -A 1 ";; ANSWER SECTION:" | tail -1 | awk '{print $5}')
    [ -z "$RESOLVED_IP" ] && STATUS="FAILED" || STATUS="OK"

    WHOIS_DATA=$(whois $IP 2>/dev/null)
    ORG=$(echo "$WHOIS_DATA" | grep -Ei "OrgName:|descr:|owner:" | head -1 | awk -F ':' '{print $2}' | xargs | cut -c1-15)
    
    # Cleaned up printf to avoid double 'ms'
    RESULT_LINE=$(printf "%-12s %-15s %-12s %-8s %-15s" "$PROVIDER_NAME" "$IP" "$LATENCY_STR" "$STATUS" "${ORG:-Unknown}")
    echo -e "${GREEN}${RESULT_LINE}${NC}"
    SAVE_BUFFER+="${RESULT_LINE}\n"
}

# --- Main Program Loop ---
while true; do
    SAVE_BUFFER="" 
    clear
    echo -e "${CYAN}======================================================================${NC}"
    echo -e "            ADVANCED GLOBAL DNS SCANNER (REFINED)"
    echo -e "${CYAN}======================================================================${NC}"
    echo -e "1) Scan All Famous Global & Local DNS"
    echo -e "2) Scan Custom IP Range"
    echo -e "3) Exit"
    echo -e "${CYAN}----------------------------------------------------------------------${NC}"
    read -p "Select an option: " MODE

    if [ "$MODE" == "3" ]; then
        echo -e "${RED}Shutting down scanner... Goodbye!${NC}"
        exit 0
    fi

    # Confirmation after choosing an option
    echo -en "\n${YELLOW}Do you want to proceed with this scan? (y/n): ${NC}"
    read -r CONFIRM
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Action cancelled. Returning to menu...${NC}"
        sleep 1
        continue
    fi

    HEADER=$(printf "%-12s %-15s %-12s %-8s %-15s" "DNS Name" "IP Address" "Latency" "Status" "Organization")
    
    if [ "$MODE" == "1" ]; then
        echo -e "\n${BOLD_GREEN}${HEADER}${NC}"
        echo -e "${BOLD_GREEN}----------------------------------------------------------------------${NC}"
        FAMOUS_LIST=(
            "Google:8.8.8.8" "Google:8.8.4.4" "Cloudflare:1.1.1.1" "Cloudflare:1.0.0.1"
            "OpenDNS:208.67.222.222" "Quad9:9.9.9.9" "AdGuard:94.140.14.14"
            "Level3:4.2.2.1" "Level3:4.2.2.4" "Verisign:64.6.64.6"
            "Shecan:178.22.122.100" "Shecan:185.51.200.2" "403:10.202.10.202"
            "Electro:78.157.42.100" "Radar:10.202.10.10"
        )
        for entry in "${FAMOUS_LIST[@]}"; do
            name="${entry%%:*}"
            ip="${entry#*:}"
            detailed_scan "$ip" "$name"
        done
    elif [ "$MODE" == "2" ]; then
        read -p "Enter DNS Name: " CUSTOM_NAME
        read -p "Enter Network (e.g. 8.8.8): " NET
        read -p "Start IP: " START
        read -p "End IP: " END
        echo -e "\n${BOLD_GREEN}${HEADER}${NC}"
        echo -e "${BOLD_GREEN}----------------------------------------------------------------------${NC}"
        for i in $(seq $START $END); do
            detailed_scan "${NET}.${i}" "$CUSTOM_NAME"
        done
    else
        echo -e "${RED}Invalid Option!${NC}"
        sleep 1
        continue
    fi

    echo -e "${BOLD_GREEN}----------------------------------------------------------------------${NC}"
    echo -en "\n${YELLOW}Save results to file? (y/n): ${NC}"
    read -r SAVE_CONFIRM
    if [[ "$SAVE_CONFIRM" =~ ^[Yy]$ ]]; then
        read -p "Enter filename: " FILENAME
        echo -e "$HEADER\n----------------------------------------------------------------------\n$SAVE_BUFFER" > "$FILENAME"
        echo -e "${GREEN}Saved to $FILENAME${NC}"
    fi
    echo -e "\n${CYAN}Scan finished. Press Enter to return to menu...${NC}"
    read
  done
