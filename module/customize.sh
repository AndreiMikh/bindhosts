#!/bin/sh
PATH=/data/adb/ap/bin:/data/adb/ksu/bin:/data/adb/magisk:$PATH
SUSFS_BIN=/data/adb/ksu/bin/ksu_susfs
. $MODPATH/utils.sh
PERSISTENT_DIR=/data/adb/bindhosts

export MODULE_HOT_INSTALL_REQUEST="true"
export MODULE_HOT_RUN_SCRIPT="hotinstall.sh"

# grab own info (version)
versionCode=$(grep versionCode "$MODPATH/module.prop" | sed 's/versionCode=//g' )

echo "📜 BindHosts v$versionCode "
echo "ℹ️ Customize"

# Function to detect key press (Volume Up or Volume Down) or timeout
detect_key_press() {
    timeout_seconds=6  # Modify this to change the wait time

    # Read input with timeout using a pipe and capture the exit code
    read -r -t $timeout_seconds line < <(getevent -ql | awk '/KEY_VOLUME/ {print; exit}')

    # Check if input was read or timed out
    if [ $? -eq 142 ]; then  # Timeout exit code
        echo "⚠️ No Key Pressed Within $timeout_seconds Seconds, Skipping Installation..."
        return 1
    fi

    # Process key press based on the detected input
    if echo "$line" | grep -q "KEY_VOLUMEUP"; then
        return 0  # Installing Bindhosts-app
    else
        echo "❌ Skipping Installation..."
        return 1
    fi
}

# Installation prompt if bindhosts app is not installed
pm path me.itejo443.bindhosts > /dev/null 2>&1 || [ -f "$PERSISTENT_DIR/bindhosts_webui" ] || {
    # Install App Section
    echo "ℹ️ BindHosts-App, Ref:github.com/itejo443/BindHosts-app"
    echo "❓ Do you Want to Install BindHosts-App"
    echo "❓ Volume Up   : Yes"
    echo "❓ Volume Down : No"
    if detect_key_press; then
        echo "📩 Installing BindHosts-App..."
	busybox chmod +x "$MODPATH/bindhosts-app.sh"
        sh "$MODPATH/bindhosts-app.sh"
    fi
}

# persistence
[ ! -d $PERSISTENT_DIR ] && mkdir -p $PERSISTENT_DIR
# make our hosts file dir
mkdir -p "$MODPATH/system/etc"

# set permissions to bindhosts.sh
busybox chmod +x "$MODPATH/bindhosts.sh"
busybox chmod +x "$MODPATH/bindhosts-app.sh"
# symlink bindhosts to manager path
# for ez termux usage
manager_paths="/data/adb/ap/bin /data/adb/ksu/bin"
for i in $manager_paths; do
	if [ -d "$i" ]; then
		echo "🔑 Creating Symlink in $i"
		ln -sf /data/adb/modules/bindhosts/bindhosts.sh "$i/bindhosts"
	fi
done

# check for other systemless hosts modules and disable them
disable_hosts_modules_verbose=1
disable_hosts_modules

# warn about highly breaking modules
# just warn and tell user to uninstall it
# we would still proceed to install
# lets make the user wait for say 5 seconds
bad_module="HideMyRoot"
for i in $bad_module; do
	if [ -d "/data/adb/modules/$i" ] ; then
		echo "🚨 Possible Confliciting Module Found!"
		echo "⚠️ $i"
		echo "📢 Uninstall for a Flawless Operation"
		echo "‼️ You have been Warned"
		sleep 5
	fi
done

# copy our old hosts file
if [ -f /data/adb/modules/bindhosts/system/etc/hosts ] ; then
	echo "ℹ️ Migrating Hosts File "
	cat /data/adb/modules/bindhosts/system/etc/hosts > "$MODPATH/system/etc/hosts"
fi

# normal flow for persistence
# move over our files, remove after
files="blacklist.txt custom.txt sources.txt whitelist.txt sources_whitelist.txt"
for i in $files ; do
	if [ ! -f "/data/adb/bindhosts/$i" ] ; then
		cat "$MODPATH/$i" > "$PERSISTENT_DIR/$i"
	fi
	rm "$MODPATH/$i"
done

# webui custom css config
if [ ! -d "$PERSISTENT_DIR/.webui_config" ] || [ ! -f "$PERSISTENT_DIR/.webui_config/custom.css" ]; then
	mkdir -p "$PERSISTENT_DIR/.webui_config"
	mv "$MODPATH/custom.css" "$PERSISTENT_DIR/.webui_config/custom.css"
else
	rm "$MODPATH/custom.css"
fi

# if hosts file empty or just comments
# just copy real hosts file over
grep -qv "#" "$MODPATH/system/etc/hosts" > /dev/null 2>&1 || {
	echo "☘️ Creating Hosts File"
	cat /system/etc/hosts > "$MODPATH/system/etc/hosts"
	printf "127.0.0.1 localhost\n::1 localhost\n" >> "$MODPATH/system/etc/hosts"
}

# set permissions always
hosts_set_perm "$MODPATH/system/etc/hosts"

# EOF
