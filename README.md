# Raspberry Pi Print Server & Health Monitor

## Introduction | บทนำ

The `raspberrypi_utils` project is designed to transform a Raspberry Pi (specifically tested on Pi 3) into a robust, headless Print Server for an HP LaserJet P3015. The project goes beyond basic setup by including automated configuration scripts, real-time health monitoring, and data logging for risk analysis, ensuring your print server runs flawlessly 24/7.

---

## System Requirements | ความต้องการของระบบ

| Component    | Recommendation / คำแนะนำ | Notes / หมายเหตุ |
|:-------------| :--- | :--- |
| **Hardware** | Raspberry Pi 3 or 4 | Tested on Pi 3 / ทดสอบแล้วบน Pi 3 |
| **Storage**  | 16GB MicroSD (A1/A2 Class) | A1/A2 class ensures longevity and better I/O performance / เพื่อความทนทานและประสิทธิภาพการอ่านเขียน |
| **Power**    | **CRITICAL: 5V 2.5A (3.0A recommended)** | *Essential* to avoid "Low Voltage" warnings during peak printing loads / **สำคัญมาก** เพื่อป้องกันปัญหาไฟตกขณะพิมพ์งานหนัก |

---

## Setup Guide | คู่มือการติดตั้ง

### 1. Run Setup Scripts / รันสคริปต์ติดตั้ง
Execute the provided scripts to configure VNC for headless mode and install print server dependencies (CUPS, HPLIP, Avahi for AirPrint).

```bash
# Configure RealVNC, switch to X11, lock resolution to 1280x720
sudo bash sh/setup/setup_headless_vnc.sh

# Install CUPS, HPLIP, and Avahi
sudo bash sh/setup/setup_print_server.sh
```

### 2. HP Printer Setup / การตั้งค่าเครื่องพิมพ์ HP
For HP printers, you must run the interactive setup tool to download proprietary plugins:

```bash
hp-setup -i
```

### 3. Printer Configuration Tips / เคล็ดลับการตั้งค่าเครื่องพิมพ์
To avoid the common **"Manual Feed"** issue (waiting for user to press OK on the printer), configure the following:


* **Default Tray:** Set to **Tray 2**.
* **Paper Type:** Set to **Plain**.
* **Physical Printer Panel:** Enable **"Override A4/Letter"** in the printer's physical settings menu.

---

## Monitoring & Health Check | การตรวจสอบสถานะระบบ

Use the `pi_health.sh` script for real-time monitoring of CPU temperature, Voltage status, RAM usage, and CUPS status with color-coded terminal output.

```bash
bash sh/pi_health.sh
```

### Understanding `vcgencmd get_throttled`
The health script decodes the throttled hex codes. This is crucial because a Raspberry Pi will throttle its CPU if the voltage drops or temperature gets too high, directly impacting print server reliability. Monitoring this ensures your power supply is adequate.

---

## 📊 Data Logging & Automation (Cron) | การเก็บบันทึกข้อมูลและอัตโนมัติ

To track system stability over time, use `pi_logger.sh` to log system metrics into `pi_status_log.csv`. Set up a Cron job to automate this process.

**Example Crontab (Logs every 5 minutes between April 17-30, 2026):**

```bash
# Open crontab editor
crontab -e

# Add the following line:
*/5 * 17-30 4 * /home/pi/pi_logger.sh
```

---

## 📈 Data Analysis | การวิเคราะห์ข้อมูล

Once data is logged to `pi_status_log.csv`, use the provided Jupyter Notebook (`pi_health.ipynb`) to analyze and visualize the system's performance.

* **Temperature Trends:** Monitor daily cooling efficiency.
* **Voltage Drop Events:** Correlate print jobs with potential power supply dips.

---

## Maintenance | การบำรุงรักษา

* **CPU Temperature:** Always keep the CPU temperature **below 80°C** to prevent thermal throttling. Consider adding a fan or heatsink if necessary.
* **Periodic Backups:** Regularly back up your MicroSD card image once your setup is perfect. MicroSD cards can fail over time due to write cycles.

