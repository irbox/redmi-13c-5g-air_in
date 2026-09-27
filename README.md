# ⛰️ Project Zenith: The-Sovereign Architecture for Redmi 13C 5G / POCO M6 5G (`air_in`)

![Android Version](https://img.shields.io/badge/Android-15-3DDC84?style=flat-square&logo=android)
![HyperOS](https://img.shields.io/badge/HyperOS-2.0-FF6900?style=flat-square)
![Requirements](https://img.shields.io/badge/Root_Required-NO-red?style=flat-square)
![Execution](https://img.shields.io/badge/Execution-Shizuku_%7C_UID_2000-blue?style=flat-square)
![Stability](https://img.shields.io/badge/Bootloop_Risk-0.000%25-brightgreen?style=flat-square)

**Project Zenith** is the ultimate non-root hardware overdrive, privacy firewall, and debloat engine for the MediaTek Dimensity 6100+ (`MT6835`) running Xiaomi HyperOS 2.0 (Android 15).

Unlike traditional "debloat" scripts that cause fatal bootloops on modern Xiaomi firmware, Zenith introduces the **AppOps Ghosting Protocol**. It mathematically blinds and paralyzes OEM surveillance and ad-networks while keeping the Android `system_server` 100% stable.

## 🚀 Key Features

* **0% Bootloop Guarantee:** Safely bypasses the hardcoded `ActivitySecurityHelper` dead-man switch in HyperOS 2.0.
* **The Ghosting Protocol:** Instead of uninstalling core system daemons (which crashes `system_server`), Zenith uses Android kernel `AppOps` to strip `INTERNET`, `CAMERA`, `RECORD_AUDIO`, and `FINE_LOCATION` from tracking apps. They remain on disk to satisfy the OS, but are perfectly deaf, blind, and paralyzed.
* **Creator-Sovereign Workflow:** Unthrottles YouTube, Google Drive, Photos, and Gmail. Google Play Services (GMS) is blinded to sensors but retains `WAKE_LOCK` and `RUN_IN_BACKGROUND` to guarantee 100% reliable Firebase Push Notifications (Port 5228).
* **Hardware Maximum Overdrive:**
  * Forces **Skia-Vulkan** (`skiavk`) 2D RenderEngine for 0ms UI latency.
  * Locks **90Hz V-Sync** & forces **280 DPI**.
  * Enables **MGLRU Gen 7** Memory Compaction & native cgroup v2 App Freezer.
  * Offloads 5G Hotspot Tethering directly to the baseband hardware.
  * Overclocks Jio 5G SA TCP window buffers (`rwnd=60`).
* **Privacy Sandbox Annihilation:** Kills the Android 15 AdServices framework globally via `aconfig` kill-switches.
* **Banking & UPI Immune:** Preserves Trustonic Kinibi TEE & Play Integrity. BHIM UPI and banking apps remain 100% functional.
* **FUSE-Bypass Persistence:** Anchors a self-healing boot script inside `/data/local/tmp/zenith/` (Device Encrypted Storage) to bypass Android 15 `/sdcard` `noexec` restrictions.

## ⚠️ Why Traditional Debloating Bricks HyperOS 2.0
If you use standard ADB tools (like Universal Android Debloater) to `pm uninstall` packages like `com.miui.gallery`, `com.xiaomi.mipicks`, or `com.miui.securitycenter`, your device **will bootloop into RescueParty**. 
Xiaomi hardcoded a security whitelist into `system_server`. If any of these packages are missing, the framework throws a `NullPointerException` and drops you into the Mi Recovery screen. **Zenith's V39 script solves this permanently by ghosting the packages instead of deleting them.**

## 🛠️ Installation & Usage

### Prerequisites
1. A Redmi 13C 5G or POCO M6 5G (`air` / `air_in`).
2. **Shizuku** (or Stellar) installed and running via Wireless Debugging (UID 2000).
3. A terminal app (e.g., Stellar's Built-In Terminal, Termux with `rish`, or aShell).

### Execution
1. Download the `zenith_v39_the_sovereign.sh` script from this repository.
2. Open your Shizuku-elevated terminal.
3. Run the script:
   ```bash
   sh /path/to/zenith_v39_the_sovereign.sh
   ```
4. The script will automatically compile your apps to machine code (AOT), ghost the telemetry, and install the boot persistence daemon.
5. **Reboot your device.**

## 📝 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. You are free to fork, modify, and distribute, provided you keep the system architectures open for everyone.

## 🤝 Acknowledgments
Forged in the fires of the 143-Domain Master Council. Built for the creators, the privacy advocates, and those who demand absolute sovereignty over their hardware.
