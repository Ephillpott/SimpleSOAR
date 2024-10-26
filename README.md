# Basic SOAR with Bash and Open Source Tools

* **Network Filtering:**  Continuously monitors network traffic and blocks connections from ITAR countries using GeoIP lookups.

* **Malware Detection and Quarantine:**  Periodically scans a specified directory for potentially malicious files using ClamAV and quarantines detected threats.

## Features

* **Network Filtering:**
    * Uses `geoiplookup` to identify and block traffic from ITAR countries.
    * Logs blocked IP addresses to `/var/log/blocked_ips.log`.
* **Malware Detection:**
    * Uses `ClamAV` to scan files for malware signatures.
    * Quarantines detected malware by moving it to a designated directory (`/path/to/quarantine`).
    * Removes execute and write permissions from quarantined files.
    * Calculates and logs the SHA-256 hash of quarantined files.
    * Records quarantine events (timestamp, filename, hash) in `/var/log/quarantined_files.log`.

## Scripts

* **`network_filter.sh`:**  Performs continuous network filtering.
* **`malware_scan.sh`:**  Performs periodic malware scanning and quarantine.


## Installation

1. **Install required packages:**

   sudo apt-get update
   sudo apt-get install geoip-bin clamav inotify-tools -y

2. **Configure scripts:**

   *  **`network_filter.sh`:**
      *   Update the `ITAR_COUNTRIES` array with the desired country codes (e.g., `ITAR_COUNTRIES=("RU" "CN" "CU")`).
      *   (Optional) Change the `LOG_FILE` variable if your network connection logs are stored in a different location.
   *  **`malware_scan.sh`:**
      *   Update `QUARANTINE_DIR` with the path to your quarantine directory (e.g., `/home/user/quarantine`).
      *   Update `MONITOR_DIR` with the directory you want to monitor for malware (e.g., `/tmp/downloads`).

3. **Create log files:**

   sudo touch /var/log/blocked_ips.log
   sudo chown $USER:$USER /var/log/blocked_ips.log
   sudo touch /var/log/quarantined_files.log
   sudo chown $USER:$USER /var/log/quarantined_files.log

## Usage
1. **Run network filtering continuously:**
  sudo nohup ./network_filter.sh &

2. **Schedule malware scanning**
  crontab -e
  0 * * * * /path/to/malware_scan.sh
