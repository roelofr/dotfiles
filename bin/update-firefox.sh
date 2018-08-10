#!/usr/bin/env bash

# CONSTANTS
# Download URL
DOWNLOAD_URL="https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"

# Enable error mode
set -e

# Get script dir and nam
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
SCRIPT_NAME="$( basename "${BASH_SOURCE[0]}" )"

# Run as root if no user was found
if [ "$( whoami )" != "root" ]; then
    # Clear sudo session
    sudo -k 

    # Builds script path
    SCRIPT="$SCRIPT_DIR/$SCRIPT_NAME"

    # Graphical?
    if xset q &>/dev/null; then
        # Prompt with gksudo
        exec gksudo --user root --description "Update Firefox binaries" "$SCRIPT"
    else
        # Prompt normally
        echo "Updating firefox..."
        exec sudo --set-home --user=root "$SCRIPT"
    fi
    exit 1
fi

# Get temp file...
DOWNLOAD_PATH="$( tempfile )"

let "MAX_FILESIZE=128 * 1024 * 1024"

# Download file
echo "Downloading new Firefox..."
curl \
    --fail \
    --location \
    --max-filesize $MAX_FILESIZE \
    --max-redirs 5 \
    --output "$DOWNLOAD_PATH" \
    --progress-bar \
    --proto '=https' \
    --url "$DOWNLOAD_URL"

# Create dir if required
[ -d /usr/lib/firefox ] || mkdir /usr/lib/firefox

# Make the directory ours, readable and enter it
chown root:root /usr/lib/firefox
chmod 0755 /usr/lib/firefox
cd /usr/lib/firefox

# Unpack files
echo "Installing new firefox version in $( pwd )..."
tar --recursive-unlink -jxvf "$DOWNLOAD_PATH" --strip-components=1

# Update links in /usr/bin
echo "Updating symlinks"
rm /usr/bin/firefox
ln -s /usr/lib/firefox/firefox /usr/bin/firefox

# Update desktop file
echo "Updating desktop file"
tee /usr/share/applications/firefox.desktop > /dev/null <<FILE
[Desktop Entry]
Encoding=UTF-8
Name=Mozilla Firefox
Comment=Browse the World Wide Web
Type=Application
Terminal=false
Exec=/usr/bin/firefox %U
Icon=/opt/firefox/icons/mozicon128.png
StartupNotify=true
Categories=Network;WebBrowser;
FILE

# Make the desktop file safe
echo "Changing permissions"
chmod 0555 /usr/share/applications/firefox.desktop

# Delete temp file
echo "Deleting download file"
rm "$DOWNLOAD_PATH"

# Done
echo "Done"




