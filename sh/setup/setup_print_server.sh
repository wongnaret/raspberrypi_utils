#!/bin/bash

echo "--- Installing & Configuring Print Server (CUPS + HPLIP) ---"

# 1. อัปเดตและติดตั้งโปรแกรมที่จำเป็น
sudo apt update
sudo apt install cups hplip avahi-daemon -y

# 2. ตั้งค่าสิทธิ์ให้ User ปัจจุบันจัดการเครื่องพิมพ์ได้
sudo usermod -a -G lpadmin $USER

# 3. เปิด Web Interface และอนุญาตการ Remote จากเครื่องอื่น
sudo cupsctl --remote-admin --remote-any --share-printers WebInterface=yes

# 4. สั่งให้ระบบเริ่มทำงาน
sudo systemctl enable cups
sudo systemctl restart cups
sudo systemctl enable avahi-daemon
sudo systemctl restart avahi-daemon

echo "----------------------------------------------------"
echo "Print Server Installed!"
echo "Access Web UI at: http://$(hostname -I | awk '{print $1}'):631"
echo "Don't forget to run 'sudo hp-setup -i' to add your P3015"
echo "----------------------------------------------------"