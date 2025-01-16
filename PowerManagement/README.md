### *Hackintosh Power Management Guide for macOS Sonoma/Sequoia*

<small>

- This guide provides step-by-step instructions for configuring **power management**, **sleep mode**, and **hibernation** on a Hackintosh running macOS Sonoma or Sequoia. 
- It includes BIOS/UEFI settings, OpenCore configuration, and `pmset` commands to optimize your system's power behavior.
- Step-by-Step Instructions with Commands and Explanations.

---

#### **Table of Contents**
1. [BIOS/UEFI Settings](#1-bios)
2. [OpenCore Configuration](#2-opencore)
3. [Check current power settings and Assertions](#3-check)
4. [Set Hibernate Mode](#4-set-hibernate-mode)
5. [Configure Sleep and Display Sleep](#5-configure-sleep-and-display-sleep)
6. [Disable Unnecessary Wake Events](#6-disable-unnecessary-wake-events)
7. [Configure Auto Power-Off](#7-configure-auto-power-off)
8. [OpenCore Configuration.Enable Necessary Quirks](#8-quirks)
9. [Debugging Sleep Issues](#8-debugging-sleep-issues)


---

<a id="1-bios"></a>
### 1. BIOS/UEFI Settings
#### Recommended Settings:
- **ErP Ready**: Disable
- **Wake on LAN**: Disable
- **Wake on USB**: Disable
- **HPET**: Enable High Precision Event Timer
- **ACPI S3**: Enable Suspend to RAM (S3 sleep)

---

<a id="2-opencore"></a>
### 2. OpenCore Configuration.Add Required Kexts
Ensure the following kexts are in your `EFI/OC/Kexts` folder and added to `config.plist`:
- **NVMeFix.kext**: [Download](https://github.com/acidanthera/NVMeFix/releases/latest)
- **USBWakeFixup.kext**: [Download](https://github.com/osy/USBWakeFixup/releases/latest)
- **HibernationFixup.kext**: [Download](https://github.com/acidanthera/HibernationFixup/releases/latest)
- **RTCMemoryFixup.kext** (Optional): [Download](https://github.com/acidanthera/RTCMemoryFixup/releases/latest)

---

<a id="3-check"></a>
### 3. Check current power settings and Assertions

Run the following command in the terminal:

> `pmset -g`

```bash
System-wide power settings:
 DestroyFVKeyOnStandby        1

Currently in use:
 Sleep On Power Button        1
 hibernatefile                /var/vm/sleepimage
 powernap                     1
 gpuswitch                    2
 networkoversleep             0
 disksleep                    10
 sleep                        1 (sleep prevented by runningboardd, runningboardd, runningboardd, coreaudiod)
 hibernatemode                25
 ttyskeepawake                1
 displaysleep                 5
 tcpkeepalive                 1
 womp                         0
```

> `pmset -g assertions`

```bash
2025-01-16 13:39:19 +0000 
Assertion status system-wide:
   BackgroundTask                 0
   ApplePushServiceTask           0
   UserIsActive                   1
   PreventUserIdleDisplaySleep    0
   PreventSystemSleep             0
   ExternalMedia                  1
   PreventUserIdleSystemSleep     1
   NetworkClientActive            0
Listed by owning process:
   pid 210(runningboardd): [0x00002b9000018a63] 01:07:36 PreventUserIdleSystemSleep named: "xpcservice<com.apple.WebKit.GPU([app<application.com.apple.Safari.65482.65637(501)>:417])(501)>{vt hash: 0}[uuid:8EC7280A-E355-425E-B63F-2012649E9C7F]:619210-417-5407:WebKit Media Playback"  
Kernel Assertions: 0x4=USB
   id=517  level=255 0x4=USB creat= description=com.apple.usb.externaldevice.00e00000 owner=Bluetooth USB Host Controller
   id=518  level=255 0x4=USB creat= description=com.apple.usb.externaldevice.01120000 owner=2.4G Wireless Receiver
   id=521  level=255 0x4=USB creat= description=com.apple.usb.externaldevice.00100000 owner=DataTraveler 80
   id=524  level=255 0x4=USB creat= description=com.apple.usb.externaldevice.00700000 owner=2.4G Wireless Receiver
   id=532  level=255 0x4=USB creat= description=com.apple.usb.externaldevice.02b00000 owner=ITE Device
   id=533  level=255 0x4=USB creat= description=com.apple.usb.externaldevice.02500000 owner=USB3.2 Hub
   id=539  level=255 0x4=USB creat= description=com.apple.usb.externaldevice.01143000 owner=Gaming Keyboard
Idle sleep preventers: IODisplayWrangler
```

- Go to Energy Saver (for desktops) or Battery (for laptops)
- To open the pane, choose Apple menu > System Settings, then click Energy  in the sidebar. (You may need to scroll down.)


| Option                                                   | Description                                                                                       | Command (Don't use this cmd)                     |
|----------------------------------------------------------|---------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------|
| **Low Power Mode**                                       | Reduce energy usage for computers that are always on (e.g., servers) and minimize fan noise.     | `sudo pmset -a lowpowermode 1`                                               |
| **Prevent automatic sleeping when the display is off**   | Prevent your Mac from going to sleep automatically when its display is off.                      |  `sudo pmset -a sleep 0`(system never sleeps)<br>`sudo pmset -a displaysleep <minutes>`<br>`sudo pmset -a disksleep <minutes>`<br> |
| **Wake for network access**                              | Allow your Mac to wake from sleep to provide access to shared resources (e.g., printers, Music). | `sudo pmset -a womp 1` (enable Wake on LAN)                                  |
| **Start up automatically after a power failure**         | Automatically start up your Mac after a power interruption.                                      | `sudo pmset -a autorestart 1`                                                |
| **Enable Power Nap**                                     | Allow your Mac to check for email, calendar, and iCloud updates while sleeping.                  | `sudo pmset -a powernap 1`                                                   |


---

<a id="4-set-hibernate-mode"></a>
### 4. Set Hibernate Mode
Configure hibernation mode based on your use case:

| Mode | Behavior | Use Case |
|------|----------|----------|
| **0** | Disables hibernation. Uses Suspend to RAM (S3 sleep). | Systems with sleep issues. |
| **3** | Safe Sleep. Saves RAM to disk but keeps RAM powered. | Laptops, systems with battery backup. |
| **25** | Deep hibernation. Saves RAM to disk and powers off completely. | Desktops, servers, long-term storage. |

### Commands:
```bash
# Deep hibernation (recommended for desktops/servers)
sudo pmset -a hibernatemode 25

# (Optional) Delete and recreate sleep image file
# sudo rm /var/vm/sleepimage
# sudo mkdir /var/vm/sleepimage
```

<a id="5-configure-sleep-and-display-sleep"></a>
### 5. Configure Sleep and Display Sleep timers to optimize power managemen
```bash
# Both options work, my choice is `Options 1`

# Options 1.Prevent System Sleep While Keeping the Display Off
# Prevent System Sleep While Keeping the Display Off
sudo pmset -a sleep 1                          # System sleeps after 1 minute of inactivity
sudo pmset -a disksleep 10                     # Disk sleeps after 10 minutes of inactivity
sudo pmset -a displaysleep 10                  # Display sleeps after 10 minutes of inactivity

Options 2. Prevent System Sleep While Keeping the Display On
# sudo pmset -a sleep 0                        # Set the sleep timer to 0.This means the system will never automatically enter sleep mode, regardless of inactivity
# sudo pmset -a disksleep 0                    # If you want to prevent the disk from sleeping as well, set the disksleep timer to 0:
# sudo pmset -a displaysleep 0                 # Set the displaysleep timer to the desired time (e.g., 5 minutes)

# Explanation:
# - `sleep`: Time (in minutes) before the system sleeps.
# - `disksleep` : Sets the time (in minutes) before the hard drive or SSD enters sleep mode when the system is idle.
# - `displaysleep`: Time (in minutes) before the display turns off.
```

<a id="6-disable-unnecessary-wake-events"></a>
### 6. Disable Unnecessary Wake Events
```bash
# Prevent the system from waking unexpectedly
sudo pmset -a womp 0                          # Disable wake on network access (Wake on LAN)
sudo pmset -a acwake 0                        # Disable wake on AC power
sudo pmset -a powernap 0                      # Power Nap can wake the system periodically. Disable it to prevent unwanted wake events.
sudo pmset -a proximitywake 0                 # Disable wake on proximity (nearby devices)
sudo pmset -a tcpkeepalive 1                  # Enables TCP Keep Alive during sleep mode - maintains network connections, perfect for remote access and server applications
sudo pmset -a ttyskeepawake 1                 # Keep system awake if remote session is active
sudo pmset -a networkoversleep 0              # Disable network access during sleep.Maximizes power savings.
```

<a id="7-configure-auto-power-off"></a>
### 7. Configure Auto Power-Off
```bash
# Set the auto power-off delay to save energy.
sudo pmset -a standby 1                       # Enable standby mode for all power sources
sudo pmset -a standbydelaylow 1               # Maximizes power savings immediately.Enters standby mode immediately (1 second)
sudo pmset -a standbydelayhigh 1                   # Maximizes power savings right away.Enters standby mode immediately (1 second)
sudo pmset -a autopoweroff 0                  # Disable automatic power-off (Option 1 turns off the PC after going into sleep mode)
sudo pmset -a autopoweroffdelay 7200          # Set auto power-off delay to 2 hours (7200 seconds)
sudo pmset -a halfdim 1                       # Enable diplay dim before sleep.is a great power-saving feature that enables display dimming before your Mac goes to sleep
sudo pmset -a autorestart 0                   # Prevent the system from restarting automatically after a power outage to avoid unnecessary power usage
````

#### Only for MacBooks and other Apple laptops
```bash
sudo pmset -a acwake 1                        # Laptops where you want the system to wake up when plugging in the charger.
sudo pmset -a lidwake 1                       # for MacBooks and other Apple laptops! This command controls whether your laptop wakes up when you open the lid
sudo pmset -a lowpowermode 1                  # For Mac laptops, use lowpowermode 1 to save battery or lowpowermode 0 for maximum performance.
sudo pmset -a highstandbythreshold 50         # Battery threshold for high-power standby.for both MacBooks and desktop Macs.
```

#### Options in my Case Mac Pro7,1
```bash
# boot-args
keepsyms=1 npci=0x2000 watchdog=0 unfairgva=1 swd_panic=1 alcid=1 -alcbeta -amfipassbeta -btlfxbeta -vsmcbeta -lilubetaall -revbeta -ctrsmt e1000=0 itlwm_cc= COUNTRY_CODE`

# config.plist
HibernateMode to None in Misc -> Boot
```
<a id="8-quirks"></a>
### 8. OpenCore Configuration.Enable Necessary Quirks
```bash
(Optional) 

# Use only if sleep or hibernation isn't working properly
# In most cases it works without these parameters

# `DiscardHibernateMap`: Discards the hibernate memory map.
# Enable the DiscardHibernateMap (Optional): Booter -> Quirks -> true

# `DisableRtcChecksum`: Disables RTC checksum validation.
# Enable DisableRTCChecksum (Optional): Kernel -> Quirks -> DisableRTCChecksum -> true

# `EnableWriteUnprotector`: Allows writing to protected memory regions.
# Enable the EnableWriteUnprotector (Optional): Booter -> Quirks -> true
```
<a id="9-debugging-sleep-issues"></a>
### 9. Debugging Sleep Issues
```bash
# Verify Current Sleep Settings
pmset -g
pmset -g assertions

# Check Wake Reason:
log show --style syslog | grep -i "Wake reason"

# Check Sleep Logs:
log show --last 1h | grep -i "sleep"
```
### Reset NVRAM:
Reboot your system and select "Reset NVRAM" from the OpenCore boot menu.

### 10. Final Notes
- Test your settings after making changes.
- Keep your kexts and OpenCore up to date.
- For Hackintoshes, ensure your ACPI/DSDT patches are correct.
  
### Check Current Power Button Behavior
- 1: The power button will put the system to sleep.
- 0: The power button will have no effect.

> `pmset -g custom`
```bash
AC Power:
 Sleep On Power Button 0
 ttyskeepawake        1
 hibernatemode        25
 powernap             1
 gpuswitch            2
 hibernatefile        /var/vm/sleepimage
 displaysleep         5
 womp                 0
 networkoversleep     0
 sleep                1
 tcpkeepalive         1
 disksleep            10
```

- To open the pane, choose Apple menu > System Settings, then click Lock Screen
- Uncheck box <Show the Sleep, Restart and Shutdown Buttons> and You have to relogin

- Before making changes, verify the current behavior of the power button:
- Press Windows + Alt and Press the power button briefly.
- Observe whether the system enters sleep mode or displays a shutdown dialog.

</small>


>>>>>>> d34b819 (Add PowerManagement folder with sleep/wake configuration scripts)

