# Project Zenith Omega: Redmi 13C 5G / POCO M6 5G (`air_in`)

[![Target SoC](https://img.shields.io/badge/SoC-MediaTek%20Dimensity%206100%2B-orange.svg)](https://www.mediatek.com/)
[![OS Support](https://img.shields.io/badge/OS-Xiaomi%20HyperOS%202.0%20(Android%2015)-blue.svg)]()
[![Bootloader Status](https://img.shields.io/badge/Bootloader-Locked%20Safe-success.svg)]()
[![Privilege](https://img.shields.io/badge/Privilege-Non--Root%20(ADB%2FShizuku)-green.svg)]()

A reverse-engineered hardware overdrive controller, display pipeline fix, and deterministic debloat suite designed exclusively for the **Redmi 13C 5G / POCO M6 5G (Code: `air_in` / Model: `23124RN87I`)** running **HyperOS 2.0 (Android 15)**.

---

## ⚡ Key Optimizations

* **SurfaceFlinger 90.00 Hz Integer Lock:** Neutralizes HyperOS dynamic float desync bugs and overrides the hardcoded 60 FPS compositor clamp on game layers.
* **Computility Tier 6 Hardware Overdrive:** Leverages the proprietary `miui.mqsas.IMQSNative` Binder interface to bypass read-only property restrictions:
  * Pins Cortex-A76 performance cores to their **2.20 GHz** silicon ceiling.
  * Pins the LITTLE efficiency cluster to a **1.70 GHz** floor.
  * Locks the MediaTek DVFSRC memory controller to **OPP 0 (4.266 GHz LPDDR4X bandwidth)**.
  * Engages the DynamIQ Shared Unit (DSU) in high-speed interconnect mode (`dsu_mode 1`).
* **Thermal Governor Bypass:** Forces `persist.sys.enable_templimit=false` into `SchedBoostService`, neutralizing user-space thermal trip down-clocking (42°C/45°C).
* **Xiaomi Greezer Buffer Extension:** Extends the kernel cgroup v2 freeze timer from 5,000 ms to **20,000 ms**, eliminating micro-stutters during task-switching.
* **Formally Verified Safe Debloat:** Unlinks 21 isolated bloatware, tracking, and ad-injecting packages without touching any of the 62 critical `android.uid.system/1000` dependencies.

---

## 🛡️ The Safety Invariant (Why This Won't Bootloop)

Standard debloat guides often brick HyperOS devices because Xiaomi binds seemingly harmless apps (such as `com.xiaomi.barrage`, `com.xiaomi.aiasst.vision`, and `com.miui.notification`) into the **`android.uid.system/1000` shared UID pool**. Removing them corrupts the package database and triggers Android's `RescueParty` recovery loop.

Every package in Zenith Omega was audited against the **5 Bootloop Invariants**:

$$\text{Safe}(P) \iff \neg \text{Persistent}(P) \land \neg \text{SharedSystemUID}(P) \land \neg \text{SystemServerBind}(P) \land \neg \text{LibraryExporter}(P)$$

### Immutable (Zero-Touch) Packages Identified & Preserved:
The script **strictly excludes** all 62 critical packages discovered during our exhaustive system audit, including:
* All `android.uid.system/1000` and `android.uid.phone/1001` shared packages.
* `com.lbe.security.miui` (Required for runtime permission dialogs).
* `com.miui.core` and `com.miui.system` (Required framework classes).
* `com.miui.home` (Preserved to maintain gesture navigation recents).
* All Runtime Resource Overlays (`.overlay` packages).

---

## 📦 Verified Bloatware Purge Suite (21 Packages)

When running `sh zenith_omega.sh debloat`, only these 100% decoupled packages are unlinked:

1. `com.mi.appfinder` (App Mall / Discover)
2. `com.mi.globalminusscreen` (App Vault / Left feed)
3. `com.mi.globallayout` (Region layout tracker)
4. `com.xiaomi.mipicks` (GetApps Store)
5. `com.xiaomi.glgm` (Game Center)
6. `com.miui.cleaner` (CleanMaster background crawler)
7. `com.xiaomi.aicr` (HyperAI recognition service)
8. `com.miui.guardprovider` (Antivirus secondary scanner)
9. `com.miui.thirdappassistant` (Third-party assistant telemetry)
10. `com.miui.miservice` (Services & feedback telemetry)
11. `com.miui.player` (Mi Music with third-party ad SDKs)
12. `com.miui.mediaviewer` (Mi Video player)
13. `com.miui.mediaeditor` (Gallery photo editor with ad trackers)
14. `com.miui.extraphoto` (Gallery sky filter bloat)
15. `com.miuix.editor` (Miuix text editor stub)
16. `com.milink.service` (Smart device interconnect sharing)
17. `com.miui.misound` (Mi Sound proprietary equalizer)
18. `com.miui.fm` (FM Radio application)
19. `com.miui.fmservice` (FM Radio background service)
20. `com.xiaomi.calendar` (MIUI Calendar - Google Calendar is standard)
21. `com.miui.backup` (MIUI Local Backup service)

---

## 🚀 Installation & Deployment

You do **not** need root or an unlocked bootloader. Run this via **ADB shell**, **Shizuku (via aShell You)**, or **Termux (`rish`)**.

### Quick Install (Single Command)

```sh
curl -sL https://raw.githubusercontent.com/<YOUR_USERNAME>/zenith-omega-air-in/main/zenith_omega.sh -o /data/local/tmp/zenith_omega.sh && chmod 755 /data/local/tmp/zenith_omega.sh
```

---

## 🎮 Usage Guide

### 1. Strip Bloatware (Run Once)
Safely unlinks all 21 verified bloatware apps and frees memory:
```sh
sh /data/local/tmp/zenith_omega.sh debloat
```

### 2. Engage Hardware Overdrive (Gaming Mode)
Pins the hardware to its silicon limits, locks 90Hz, and uncaps thermals:
```sh
# Defaults to BGMI (com.pubg.imobile)
sh /data/local/tmp/zenith_omega.sh game

# Or pass a custom game package name:
sh /data/local/tmp/zenith_omega.sh game com.dts.freefireth
```

### 3. Check Live Hardware Status
Verifies active CPU frequencies, SurfaceFlinger render rate, and governor states:
```sh
sh /data/local/tmp/zenith_omega.sh status
```

*Expected Status Output during Overdrive:*
```text
Display Render Cadence : renderRate=90.00 Hz
CPU Little Cores (0-5) : 1700000 kHz
CPU Big Cores (6-7 A76): 2200000 kHz
Thermal Throttle Check : false
Computility Power Tier : 6
Greezer Freeze Timeout : 20000 ms
```

### 4. Restore Balanced Profile (Daily Driver Mode)
Restores stock adaptive refresh rate and thermal safeguards after gaming:
```sh
sh /data/local/tmp/zenith_omega.sh balance
```

### 5. Maximum Endurance Mode (Battery Saver)
Clamps display to 60Hz and reduces CPU/GPU to Tier 1:
```sh
sh /data/local/tmp/zenith_omega.sh battery
```

### 6. Emergency Rollback (Restore All Bloatware)
If you ever want to re-install all unlinked OEM apps:
```sh
sh /data/local/tmp/zenith_omega.sh restore
```

---

## ⚠️ Known Platform Behaviors

1. **Third-Party Launchers:** HyperOS gesture navigation is compiled into `com.miui.home`. If you install an open-source AOSP launcher (such as Lawnchair), you must switch navigation to **3-button mode** in Settings before switching launchers.
2. **Idle Frequency Scaling:** When sitting idle in a terminal, Linux's `sugov_ext` governor scales the CPU down to 850MHz/1.4GHz to save power. Computility Tier 6 ensures that the moment workload or touch input occurs, Cores 6 and 7 instantly spike to **2.20 GHz** without governor lag.

---

## 📄 License
This project is open-source under the MIT License.

---
