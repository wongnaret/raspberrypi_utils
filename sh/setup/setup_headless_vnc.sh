#!/bin/bash

echo "--- Configuring Headless VNC & Resolution ---"

# 1. เปิดใช้งาน VNC Server
sudo raspi-config nonint do_vnc 0

# 2. สลับจาก Wayland เป็น X11 (สำคัญมากสำหรับ RealVNC บน Pi 3)
sudo raspi-config nonint do_wayland W1

# 3. แก้ไข config.txt เพื่อล็อก Resolution
CONFIG_PATH="/boot/firmware/config.txt"
[ ! -f "$CONFIG_PATH" ] && CONFIG_PATH="/boot/config.txt"

# ลบค่าเก่าที่อาจจะซ้ำซ้อนออกก่อน
sudo sed -i '/hdmi_force_hotplug/d' $CONFIG_PATH
sudo sed -i '/hdmi_group/d' $CONFIG_PATH
sudo sed -i '/hdmi_mode/d' $CONFIG_PATH
sudo sed -i '/hdmi_drive/d' $CONFIG_PATH

# ใส่ค่าใหม่ลงไป (Group 2 Mode 85 = 1280x720 @ 60Hz)
sudo bash -c "cat >> $CONFIG_PATH" << EOT
hdmi_force_hotplug=1
hdmi_group=2
hdmi_mode=85
hdmi_drive=2
EOT

echo "Done! Please reboot to apply changes."