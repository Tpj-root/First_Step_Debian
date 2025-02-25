#!/bin/bash
# Add the alias
# alias mouse_fix='sudo bash /home/cnc/Desktop/GIT_MAIN/ShadowShell/reset_mouse.sh'
# Function to reset a USB device using unbind/rebind
reset_usb_device() {
    DEVICE_PATH=$1
    echo "Resetting device: $DEVICE_PATH"
    echo "$DEVICE_PATH" | sudo tee /sys/bus/usb/drivers/usb/unbind > /dev/null
    echo "$DEVICE_PATH" | sudo tee /sys/bus/usb/drivers/usb/bind > /dev/null
}

# Find all USB devices
USB_DEVICES=$(ls /sys/bus/usb/devices/ | grep -E '[0-9]+-[0-9]+')

# Iterate over all devices and reset them
for USB_DEVICE in $USB_DEVICES; do
    if [[ -d "/sys/bus/usb/devices/$USB_DEVICE" ]]; then
        reset_usb_device "$USB_DEVICE"
    else
        echo "Device path /sys/bus/usb/devices/$USB_DEVICE not found. Skipping."
    fi
done

echo "All USB devices have been reset."

