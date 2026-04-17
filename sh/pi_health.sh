#!/bin/bash

# --- Color Definitions ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}   RASPBERRY PI HEALTH & RISK MONITOR     ${NC}"
echo -e "${BLUE}==========================================${NC}"

# 1. CPU Temperature
TEMP=$(vcgencmd measure_temp | egrep -o '[0-9.]+')
echo -ne "CPU Temperature: "
if (( $(echo "$TEMP > 80" | bc -l) )); then
    echo -e "${RED}${TEMP}°C (DANGER: Throttling soon)${NC}"
elif (( $(echo "$TEMP > 65" | bc -l) )); then
    echo -e "${YELLOW}${TEMP}°C (WARNING: Getting hot)${NC}"
else
    echo -e "${GREEN}${TEMP}°C (Normal)${NC}"
fi

# 2. Voltage & Throttling Status
THROTTLED=$(vcgencmd get_throttled | cut -d "=" -f2)
echo -ne "Voltage Status:  "
if [ "$THROTTLED" == "0x0" ]; then
    echo -e "${GREEN}Stable (No issues)${NC}"
else
    echo -e "${RED}ISSUE DETECTED ($THROTTLED)${NC}"
    # Bitwise checks
    [[ $((THROTTLED & 0x1)) -ne 0 ]] && echo -e "  - ${RED}[!] Under-voltage NOW${NC}"
    [[ $((THROTTLED & 0x10000)) -ne 0 ]] && echo -e "  - ${YELLOW}[!] Under-voltage HAS OCCURRED${NC}"
    [[ $((THROTTLED & 0x2)) -ne 0 ]] && echo -e "  - ${RED}[!] Arm frequency capped (Throttling)${NC}"
fi

# 3. Memory Usage
MEM=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
echo -e "RAM Usage:       ${YELLOW}$MEM${NC}"

# 4. SD Card Usage (32GB)
DISK=$(df -h / | awk 'NR==2{print $5}')
echo -e "Disk Usage (/):  ${YELLOW}$DISK${NC}"

# 5. CUPS (Print Server) Status
echo -ne "Print Server:    "
CUPS_STATUS=$(systemctl is-active cups)
if [ "$CUPS_STATUS" == "active" ]; then
    echo -e "${GREEN}Running${NC}"
else
    echo -e "${RED}Stopped (CUPS is offline!)${NC}"
fi

# 6. Print Jobs in Queue
JOBS=$(lpstat -o | wc -l)
echo -e "Print Jobs:      ${YELLOW}$JOBS job(s) in queue${NC}"

# 7. Network Info
IP=$(hostname -I | awk '{print $1}')
echo -e "Local IP:        ${BLUE}$IP${NC}"

echo -e "${BLUE}==========================================${NC}"
