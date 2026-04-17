#!/bin/bash

# กำหนดชื่อไฟล์และเส้นทางที่จะเก็บ (เปลี่ยนได้ตามต้องการ)
LOG_FILE="/home/kea/pi_status_log.csv"

# 1. เตรียมข้อมูล
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
TEMP=$(vcgencmd measure_temp | egrep -o '[0-9.]+')
VOLT_HEX=$(vcgencmd get_throttled | cut -d "=" -f2)
RAM_USAGE=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')
DISK_USAGE=$(df -h / | awk 'NR==2{print $5}' | sed 's/%//')
CUPS_STATUS=$(systemctl is-active cups)
PRINT_JOBS=$(lpstat -o | wc -l)

# 2. ตรวจสอบว่ามีไฟล์ CSV หรือยัง ถ้าไม่มีให้สร้าง Header
if [ ! -f "$LOG_FILE" ]; then
    echo "Timestamp,Temperature_C,Voltage_Hex,RAM_Usage_Percent,Disk_Usage_Percent,CUPS_Status,Queue_Jobs" > "$LOG_FILE"
fi

# 3. บันทึกข้อมูลลงไฟล์ CSV
echo "$TIMESTAMP,$TEMP,$VOLT_HEX,$RAM_USAGE,$DISK_USAGE,$CUPS_STATUS,$PRINT_JOBS" >> "$LOG_FILE"
