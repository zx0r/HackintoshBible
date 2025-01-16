#!/bin/bash

# NOTE ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

#      __ __         __    _      __           __     __
#     / // /__  ____/ /__ (_)__  / / ___  ___ / /    / /  ___  ___ ____
#    / _  / _ `/ __/  '_// / _ \/ __/ _ \(_-</ _ \  / /__/ _ \/ _ `(_-<
#   /_//_/\_,_/\__/_/\_\/_/_//_/\__/\___/___/_//_/ /____/\___/\_, /___/
#   Copyright (c) 2024 for the Hackintosh community          /___/
#
#  Author       : zx0r
#  License      : MIT License
#  Contact Info : https://github.com/zx0r
#  Description  : Stay Hungry, Stay Foolish" - Steve Jobs
#  macOS Power Management Configuration Script
#  Purpose: Configure optimal power settings for desktop/laptop
#  Usage: sudo bash power-settings.sh

# ━━━ Dump Logs ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# 1. OpenCore Configuration.Add Required Kexts to Kernel -> Add
# - Ensure the following kexts are in your `EFI/OC/Kexts` folder and added to `config.plist`:
# - NVMeFix.kext: [Download](https://github.com/acidanthera/NVMeFix/releases/latest)
# - USBWakeFixup.kext: [Download](https://github.com/osy/USBWakeFixup/releases/latest)
# - HibernationFixup.kext: [Download](https://github.com/acidanthera/HibernationFixup/releases/latest)
# - RTCMemoryFixup.kext (Optional): [Download](https://github.com/acidanthera/RTCMemoryFixup/releases/latest)

# 2. Set HibernateMode to None in Misc -> Boot
# (Optional) In most cases it works without these parameters
# 3. Enable DisableRTCChecksum (Optional): Kernel -> Quirks -> DisableRTCChecksum -> true
# 4. Enable the DiscardHibernateMap (Optional): Booter -> Quirks -> true

# 3. (Optional) OpenCore Configuration.Enable Necessary Quirks

# Use only if sleep or hibernation isn't working properly
# In most cases it works without these parameters

# `DiscardHibernateMap`: Discards the hibernate memory map.
# Enable the DiscardHibernateMap (Optional): Booter -> Quirks -> true

# `DisableRtcChecksum`: Disables RTC checksum validation.
# Enable DisableRTCChecksum (Optional): Kernel -> Quirks -> DisableRTCChecksum -> true

# `EnableWriteUnprotector`: Allows writing to protected memory regions.
# Enable the EnableWriteUnprotector (Optional): Booter -> Quirks -> true

# Check for root privileges
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

echo "Configuring macOS Power Management Settings..."

# Only for MacBooks and other Apple laptops
# echo "Configuring battery and lid settings..."
# pmset -a highstandbythreshold 50          # Battery threshold for high-power standby.for both MacBooks and desktop Macs.
# pmset -a lidwake 1                        # for MacBooks and other Apple laptops! This command controls whether your laptop wakes up when you open the lid
# pmset -a lowpowermode 1                   # For Mac laptops, use lowpowermode 1 to save battery or lowpowermode 0 for maximum performance.
# pmset -a acwake 1                         # Laptops where you want the system to wake up when plugging in the charger.

# Basic Power Settings
echo "Setting up basic power parameters..."
pmset -a sleep 1                           # Put the disk to sleep after 10 minutes of inactivity
pmset -a halfdim 1                         # Enable diplay dim before sleep.is a great power-saving feature that enables display dimming before your Mac goes to sleep

# Sleep and Hibernation
echo "Configuring sleep and hibernation..."
pmset -a disksleep 10                      # Set hard disk to sleep after 5 minutes
pmset -a displaysleep 5                    # Display sleep after 5 minutes of inactivity
pmset -a hibernatemode 25                  # Safe sleep mode (RAM + disk)
pmset -a hibernatefile /var/vm/sleepimage  # Hibernate image file location

# Power Nap and Network
echo "Setting up Power Nap and network behavior..."
pmset -a womp 0                            # Wake on network access.When WoMP is enabled,Mac can be woken up remotely from sleep mode a special network packet "Magic Packet"
pmset -a acwake 0                          # Prevent the system from waking on AC power (0 = disabled).For desktop use 0.
pmset -a powernap 0                        # Power Nap can wake the system periodically.Enable Power Nap feature to check for updates/emails during sleep
pmset -a networkoversleep 0                # Disable network access during sleep.Maximizes power savings.
pmset -a proximitywake 0                   # Disable waking the system when nearby devices are detected (0 = disabled)
pmset -a tcpkeepalive 1                    # Enables TCP Keep Alive during sleep mode - maintains network connections, perfect for remote access and server applications
pmset -a ttyskeepawake 1                   # Keep system awake if remote session is active

# Advanced Power Settings
echo "Setting up advanced power parameters..."
pmset -a standby 1                         # Enable standby mode for all power sources
pmset -a standbydelaylow 1                 # Maximizes power savings immediately.Enters standby mode after just 1 second
pmset -a standbydelayhigh 1                # Maximizes power savings right away.Enters standby mode immediately (1 second)
pmset -a autopoweroff 0                    # Disable automatic power-off.Do not use 1, automatically Power turns off after entering sleep mode.
pmset -a autopoweroffdelay 7200            # Set auto power off delay 2 hours in seconds
# pmset -a autorestart 1                   # Enable automatic restart after power loss

# Verify settings
echo "Verifying all power management settings..."
pmset -g
# pmset -g assertions

echo "Power management configuration completed successfully!"

