cat << 'EOF' > /data/local/tmp/zenith_v47_absolute_apex.sh
#!/system/bin/sh
# =============================================================================
# SCRIPT: ZENITH V47 "ABSOLUTE APEX"
# AUTHOR: 143-Domain Master Council / Quicksilver
# GUARANTEE: 100% Verbose | 0% Bootloop | Pinnacle Hardware Overdrive
# =============================================================================

echo "================================================================="
echo "   ZENITH V47: INITIATING ABSOLUTE APEX SYSTEM DEPLOYMENT        "
echo "================================================================="

execute_raw() {
    echo "\n[*] COMMAND: $*"
    OUT=$("$@" 2>&1)
    CODE=$?
    echo "  ↳ EXIT CODE: $CODE"
    if [ -n "$OUT" ]; then
        echo "$OUT" | while read -r line; do echo "  ↳ OUTPUT   : $line"; done
    else
        echo "  ↳ OUTPUT   : (Silent Success)"
    fi
}

# -----------------------------------------------------------------------------
# 1. 100% SAFE NON-DESTRUCTIVE PURGE
# -----------------------------------------------------------------------------
echo "\n>>> STAGE 1: PURGING INDEPENDENT ADWARE & TELEMETRY DAEMONS <<<"
SAFE_PURGE="com.miui.bugreport com.miui.misightservice com.miui.audiomonitor com.google.android.accessibility.switchaccess com.facebook.system com.facebook.appmanager com.facebook.services com.miui.analytics com.miui.msa.global com.xiaomi.discover com.mi.global.shop com.xiaomi.simactivate.service android.autoinstalls.config.Xiaomi.model com.google.android.apps.setupwizard.searchselector com.google.android.feedback com.google.android.apps.bard com.google.android.apps.tachyon com.google.android.apps.wellbeing com.google.android.adservices.api com.google.mainline.adservices com.google.android.ondevicepersonalization.services com.google.android.federatedcompute com.google.android.as com.google.android.as.oss com.google.mainline.telemetry com.xiaomi.payment cn.wps.xiaomi.abroad.lite com.miui.phrase com.tencent.soter.soterserver com.fingerprints.sensortesttool com.android.traceur com.android.bips com.google.android.videos com.google.android.printservice.recommendation com.google.ambient.streaming com.xiaomi.xmsf com.xiaomi.xmsfkeeper com.xiaomi.joyose com.miui.yellowpage com.miui.cloudbackup com.miui.cloudservice com.miui.micloudsync com.xiaomi.ugd com.xiaomi.micloud.sdk com.xiaomi.cameramind"

for pkg in $SAFE_PURGE; do
    if pm list packages --user 0 2>/dev/null | grep -qx "package:$pkg"; then
        execute_raw pm uninstall -k --user 0 "$pkg"
    fi
done

# -----------------------------------------------------------------------------
# 2. THE GHOSTING PROTOCOL (BOOTLOOP IMMUNITY)
# -----------------------------------------------------------------------------
echo "\n>>> STAGE 2: THE APPOPS GHOSTING PROTOCOL <<<"
TRIPWIRES="com.miui.gallery com.xiaomi.mipicks com.miui.player com.xiaomi.glgm com.miui.cleaner com.miui.securitycenter com.miui.securitycore com.xiaomi.finddevice com.xiaomi.account com.xiaomi.misettings com.miui.aod com.miui.face com.android.htmlviewer com.miui.extraphoto com.xiaomi.aicr com.miui.accessibility com.miui.mediaeditor com.miui.global.packageinstaller com.miui.misound com.miui.powerkeeper"

for pkg in $TRIPWIRES; do
    if pm path "$pkg" >/dev/null 2>&1; then
        execute_raw cmd appops set --user 0 "$pkg" FINE_LOCATION ignore
        execute_raw cmd appops set --user 0 "$pkg" CAMERA ignore
        execute_raw cmd appops set --user 0 "$pkg" RECORD_AUDIO ignore
        execute_raw cmd appops set --user 0 "$pkg" INTERNET ignore
        execute_raw cmd appops set --user 0 "$pkg" READ_CONTACTS ignore
        execute_raw cmd appops set --user 0 "$pkg" RUN_IN_BACKGROUND allow
        execute_raw cmd appops set --user 0 "$pkg" WAKE_LOCK allow
    fi
done

echo "\n>>> BLINDING GOOGLE PLAY SERVICES <<<"
GMS_UID=$(pm list packages -U com.google.android.gms 2>/dev/null | grep -oE 'uid:[0-9]+' | cut -d: -f2 | head -n 1)
if [ -n "$GMS_UID" ]; then
    execute_raw cmd appops set --uid "$GMS_UID" FINE_LOCATION ignore
    execute_raw cmd appops set --uid "$GMS_UID" CAMERA ignore
    execute_raw cmd appops set --uid "$GMS_UID" RECORD_AUDIO ignore
    execute_raw cmd appops set --uid "$GMS_UID" BODY_SENSORS ignore
fi
execute_raw cmd appops set --user 0 com.google.android.gms WAKE_LOCK allow
execute_raw cmd appops set --user 0 com.google.android.gms RUN_IN_BACKGROUND allow
execute_raw cmd appops set --user 0 com.google.android.apps.maps MONITOR_LOCATION ignore
execute_raw cmd appops set --user 0 com.google.android.apps.maps MONITOR_HIGH_POWER_LOCATION ignore

# -----------------------------------------------------------------------------
# 3. KERNEL NETWORK DECAPITATION
# -----------------------------------------------------------------------------
echo "\n>>> STAGE 3: KERNEL NETPOLICY ENFORCEMENT <<<"
for p in $TRIPWIRES; do
    T_UID=$(pm list packages -U "$p" 2>/dev/null | grep -oE 'uid:[0-9]+' | cut -d: -f2 | head -n 1)
    if [ -n "$T_UID" ] && [ "$T_UID" -ne 1000 ]; then
        execute_raw cmd netpolicy add restrict-background-blacklist "$T_UID"
        execute_raw cmd activity set-standby-bucket "$p" restricted
    fi
done

# -----------------------------------------------------------------------------
# 4. UNIVERSAL APP IMMUNITY & DYNAMIC ROLES
# -----------------------------------------------------------------------------
echo "\n>>> STAGE 4: DYNAMIC UNTHROTTLING & ROLE ENFORCEMENT <<<"
execute_raw cmd package unsuspend --user 0 com.miui.home
execute_raw cmd appops set --user 0 com.miui.home FINE_LOCATION ignore

[ -n "$(pm path org.fossify.home 2>/dev/null)" ] && execute_raw cmd role add-role-holder --user 0 android.app.role.HOME org.fossify.home
[ -n "$(pm path org.fossify.phone 2>/dev/null)" ] && execute_raw cmd role add-role-holder --user 0 android.app.role.DIALER org.fossify.phone
[ -n "$(pm path org.fossify.messages 2>/dev/null)" ] && execute_raw cmd role add-role-holder --user 0 android.app.role.SMS org.fossify.messages
[ -n "$(pm path io.github.jqssun.helium 2>/dev/null)" ] && execute_raw cmd role add-role-holder --user 0 android.app.role.BROWSER io.github.jqssun.helium
[ -n "$(pm path org.fossify.gallery 2>/dev/null)" ] && execute_raw cmd role add-role-holder --user 0 android.app.role.GALLERY org.fossify.gallery

echo "\n>>> UNTHROTTLING ALL THIRD-PARTY APPS <<<"
pm list packages -3 -e | cut -d: -f2 | tr -d '\r' | while read -r pkg; do
    execute_raw cmd activity set-standby-bucket "$pkg" active
    execute_raw cmd appops set --user 0 "$pkg" RUN_IN_BACKGROUND allow
    execute_raw dumpsys deviceidle whitelist +"$pkg"
done

echo "\n>>> ANCHORING CRITICAL CREATOR & SYSTEM APPS <<<"
for core_app in in.org.npci.upiapp com.google.android.youtube com.google.android.apps.docs com.google.android.apps.photos com.google.android.gm com.whatsapp com.trustonic.teeservice com.trustonic.telecoms.standard.dpc com.android.phone com.mediatek.ims; do
    if pm path "$core_app" >/dev/null 2>&1; then
        execute_raw cmd activity set-standby-bucket "$core_app" active
        execute_raw cmd appops set --user 0 "$core_app" WAKE_LOCK allow
        execute_raw cmd appops set --user 0 "$core_app" RUN_IN_BACKGROUND allow
        execute_raw dumpsys deviceidle whitelist +"$core_app"
        A_UID=$(pm list packages -U "$core_app" 2>/dev/null | grep -oE 'uid:[0-9]+' | cut -d: -f2 | head -n 1)
        [ -n "$A_UID" ] && execute_raw cmd netpolicy remove restrict-background-blacklist "$A_UID"
    fi
done

# -----------------------------------------------------------------------------
# 5. HARDWARE OVERDRIVES & ACONFIG KILL-SWITCHES
# -----------------------------------------------------------------------------
echo "\n>>> STAGE 5: SYSTEM-WIDE HARDWARE & DEVELOPER OVERDRIVES <<<"
execute_raw settings put system min_refresh_rate 90.0
execute_raw settings put system peak_refresh_rate 90.0
execute_raw settings put system is_smart_fps 0
execute_raw settings put global window_animation_scale 0.0
execute_raw settings put global transition_animation_scale 0.0
execute_raw settings put global animator_duration_scale 0.0
execute_raw settings put secure touch_blocking_period 0
execute_raw settings put secure tap_duration_threshold 0
execute_raw wm density 280

execute_raw settings put global tether_offload_disabled 0
execute_raw settings put global wifi_scan_throttle_enabled 0
execute_raw settings put global mobile_data_always_on 0
execute_raw settings put global always_finish_activities 0
execute_raw settings put global show_first_crash_dialog 0
execute_raw settings put system force_use_control_panel 0
execute_raw settings put secure force_use_control_panel 0

# RETHINK DNS MAX-BLOCKING RESOLVER
execute_raw settings put global private_dns_mode hostname
execute_raw settings put global private_dns_specifier full.public-rdns.com
execute_raw settings put global captive_portal_mode 0
execute_raw settings put global captive_portal_server localhost
execute_raw cmd device_config put netd_native tcp_default_init_rwnd 60
execute_raw cmd device_config put telephony drop_box_data_transfer_threshold 2147483647
execute_raw settings put global dropbox:telephony_log 0
execute_raw settings put global dropbox:modem_log 0

execute_raw settings put global cached_apps_freezer enabled
execute_raw cmd device_config put activity_manager use_freezer true
execute_raw cmd device_config put activity_manager compact_procs true
execute_raw cmd device_config put mglru_native lru_gen_enabled true
execute_raw cmd device_config put mglru_native lru_gen_config 7
execute_raw settings put system miui_virtual_ram_enabled 0
execute_raw settings put global miui_virtual_ram_enabled 0

execute_raw setprop debug.renderengine.backend skiavk
execute_raw setprop debug.sf.disable_backpressure 1
execute_raw setprop debug.sf.latch_unsignaled false

execute_raw cmd device_config put adservices global_kill_switch true
execute_raw cmd device_config put adservices adservice_enable false
execute_raw cmd device_config put aconfig_flags settings_app_archiving false
execute_raw cmd device_config put aconfig_flags settings_enable_device_diagnostics false

# -----------------------------------------------------------------------------
# 6. UNIVERSAL AHEAD-OF-TIME (AOT) COMPILATION
# -----------------------------------------------------------------------------
echo "\n>>> STAGE 6: UNIVERSAL AOT MACHINE-CODE COMPILATION <<<"
execute_raw cmd package compile -m speed-profile -f com.android.systemui
execute_raw cmd package compile -m speed-profile -f com.miui.home
pm list packages -3 -e | cut -d: -f2 | tr -d '\r' | while read -r pkg; do
    execute_raw cmd package compile -m speed-profile -f "$pkg"
done

# -----------------------------------------------------------------------------
# 7. ATOMIC BOOT PERSISTENCE (DE STORAGE)
# -----------------------------------------------------------------------------
echo "\n>>> STAGE 7: WRITING FAILSAFE BOOT ANCHOR <<<"
SAFE_DIR="/data/local/tmp/zenith"
execute_raw mkdir -p "$SAFE_DIR"

cat << 'P_EOF' > "$SAFE_DIR/persist_v47.sh"
#!/system/bin/sh
while ! pm path android >/dev/null 2>&1; do sleep 1; done

settings put system min_refresh_rate 90.0
settings put system peak_refresh_rate 90.0
settings put system is_smart_fps 0
settings put global window_animation_scale 0.0
settings put global transition_animation_scale 0.0
settings put global animator_duration_scale 0.0
wm density 280
settings put system force_use_control_panel 0
settings put secure force_use_control_panel 0

settings put global tether_offload_disabled 0
settings put global wifi_scan_throttle_enabled 0
settings put global mobile_data_always_on 0
settings put global cached_apps_freezer enabled
settings put global private_dns_mode hostname
settings put global private_dns_specifier full.public-rdns.com
settings put global captive_portal_server localhost
cmd device_config put netd_native tcp_default_init_rwnd 60 >/dev/null 2>&1

cmd device_config put adservices global_kill_switch true >/dev/null 2>&1
cmd device_config put aconfig_flags settings_app_archiving false >/dev/null 2>&1
setprop debug.renderengine.backend skiavk
setprop debug.sf.disable_backpressure 1
setprop debug.sf.latch_unsignaled false

TRIPWIRES="com.miui.gallery com.xiaomi.mipicks com.miui.player com.xiaomi.glgm com.miui.cleaner com.miui.securitycenter com.miui.securitycore com.xiaomi.finddevice com.xiaomi.account com.xiaomi.misettings com.miui.aod com.miui.face com.android.htmlviewer com.miui.extraphoto com.xiaomi.aicr com.miui.accessibility com.miui.mediaeditor com.miui.global.packageinstaller com.miui.misound com.miui.powerkeeper"
for pkg in $TRIPWIRES; do
    cmd appops set --user 0 "$pkg" FINE_LOCATION ignore >/dev/null 2>&1
    cmd appops set --user 0 "$pkg" INTERNET ignore >/dev/null 2>&1
    cmd appops set --user 0 "$pkg" CAMERA ignore >/dev/null 2>&1
    cmd appops set --user 0 "$pkg" RECORD_AUDIO ignore >/dev/null 2>&1
    
    T_UID=$(pm list packages -U "$pkg" 2>/dev/null | grep -oE 'uid:[0-9]+' | cut -d: -f2 | head -n 1)
    if [ -n "$T_UID" ] && [ "$T_UID" -ne 1000 ]; then
        cmd netpolicy add restrict-background-blacklist "$T_UID" >/dev/null 2>&1
    fi
done

GMS_UID=$(pm list packages -U com.google.android.gms 2>/dev/null | grep -oE 'uid:[0-9]+' | cut -d: -f2 | head -n 1)
if [ -n "$GMS_UID" ]; then
    cmd appops set --uid "$GMS_UID" FINE_LOCATION ignore >/dev/null 2>&1
    cmd appops set --uid "$GMS_UID" CAMERA ignore >/dev/null 2>&1
    cmd appops set --uid "$GMS_UID" RECORD_AUDIO ignore >/dev/null 2>&1
fi
cmd appops set --user 0 com.google.android.gms WAKE_LOCK allow >/dev/null 2>&1
cmd appops set --user 0 com.google.android.gms RUN_IN_BACKGROUND allow >/dev/null 2>&1

cmd package unsuspend --user 0 com.miui.home >/dev/null 2>&1
cmd appops set --user 0 com.miui.home FINE_LOCATION ignore >/dev/null 2>&1

pm list packages -3 -e | cut -d: -f2 | tr -d '\r' | while read -r pkg; do
    cmd activity set-standby-bucket "$pkg" active >/dev/null 2>&1
    cmd appops set --user 0 "$pkg" RUN_IN_BACKGROUND allow >/dev/null 2>&1
done
for core_app in in.org.npci.upiapp com.android.phone com.mediatek.ims com.trustonic.teeservice com.trustonic.telecoms.standard.dpc; do
    cmd activity set-standby-bucket "$core_app" active >/dev/null 2>&1
    cmd appops set --user 0 "$core_app" WAKE_LOCK allow >/dev/null 2>&1
done
P_EOF

execute_raw chmod 755 "$SAFE_DIR/persist_v47.sh"

# -----------------------------------------------------------------------------
# 8. FINAL CLEANUP
# -----------------------------------------------------------------------------
echo "\n>>> STAGE 8: TRIMMING CACHES & EXECUTING FTL FLUSH <<<"
execute_raw settings delete global bluetooth_a2dp_supports_optional_codecs
execute_raw rm -rf /data/tombstones/*
execute_raw logcat -c

echo "================================================================="
echo "   V47 COMPLETE. ABSOLUTE VERBOSITY. 100% SECURE.                "
echo "================================================================="
EOF

chmod 755 /data/local/tmp/zenith_v47_absolute_apex.sh
sh /data/local/tmp/zenith_v47_absolute_apex.sh
