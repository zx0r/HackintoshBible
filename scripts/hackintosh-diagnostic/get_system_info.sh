#!/bin/bash

# Model: MacPro7,1, BootROM 2069.0.0.0.0, 12 processors, AMD Ryzen™ 9 7900X 12-Core Processor, 405 MHz, 48 GB, SMC
# Graphics: AMD Radeon RX 6900 XT, AMD Radeon RX 6900 XT, PCIe, 16 GB
# Display: Q32G1WG4, 2560 x 1440 (QHD/WQHD - Wide Quad High Definition), Main, MirrorOff, Online
# Memory Module: P0 CHANNEL A/DIMM 1, 24 GB, RAM, 6400 MHz, G.SKILL, F5-6400J4048F24G
# Memory Module: P0 CHANNEL B/DIMM 1, 24 GB, RAM, 6400 MHz, G.SKILL, F5-6400J4048F24G
# AirPort: spairport_wireless_card_type_wifi (0x8086, 0x24), itlwm: 2.4.0 fw: 68.01d30b0c.0
# Bluetooth: Version (null), 0 services, 0 devices, 0 incoming serial ports
# Network Service: Ethernet, Ethernet, en0
# Network Service: Wi-Fi, AirPort, en1
# PCI Card: FCH SMBus Controller, SMBus, Internal@0,20,0
# PCI Card: Samsung 990 PRO  PCIe 4.0 NVMe M.2 SSD, Non-Volatile memory controller, Internal@0,1,2/0,0
# PCI Card: Kingston FURY Renegade PCIe 4.0 NVMe M.2 SSD, Non-Volatile memory controller, Internal@0,2,2/0,0
# PCI Card: Phoenix PCIe Dummy Function, Non-Essential Instrumentation, Internal@0,8,1/0,0
# PCI Card: VanGogh PSP/CCP, Encryption controller, Internal@0,8,1/0,2
# PCI Card: Family 17h/19h HD Audio Controller, Audio device, Internal@0,8,1/0,6
# PCI Card: AMD Radeon RX 6900 XT, gpu-controller, Internal@0,1,1/0,0/0,0@3,0,0
# PCI Card: Navi 21/23 HDMI/DP Audio Controller, Audio device, Internal@0,1,1/0,0/0,0/0,1
# PCI Card: Ethernet Controller I225-V, Ethernet controller, Internal@0,2,1/0,0/8,0/0,0/6,0/0,0
# PCI Card: Wi-Fi 6E AX210 160MHz, Network controller, Internal@0,2,1/0,0/8,0/0,0/7,0/0,0
# USB Device: USB32Bus
# USB Device: ITE Device
# USB Device: USB2.1 Hub
# USB Device: USB3.2 Hub
# USB Device: USB31Bus
# USB Device: USB30Bus
# USB Device: USB2.0 Hub
# USB Device: USB 2.0 Hub
# USB Device: Gaming Keyboard
# USB Device: 2.4G Wireless Receiver
# USB Device: USB31Bus
# USB Device: USB32Bus
# USB Device: Bluetooth USB Host Controller
# USB Device: 2.4G Wireless Receiver
# USB Device: DataTraveler 80
# Thunderbolt Bus:

# Function to get system model
get_model() {
  sysctl hw.model | awk '{print $2}'
}

# Function to get BootROM version
get_bootrom() {
  system_profiler SPHardwareDataType | awk -F': ' '/Boot ROM Version/ {print $2}'
}

# Function to get processor information
get_processors() {
  sysctl -n machdep.cpu.brand_string
}

# Function to get CPU frequency
get_cpu_freq() {
  sysctl hw.cpufrequency | awk '{printf "%.0f MHz\n", $2 / 1000000}'
}

# Function to get total memory
get_memory() {
  sysctl hw.memsize | awk '{printf "%d GB\n", $2 / 1073741824}'
}

# Function to get SMC version
get_smc() {
  system_profiler SPHardwareDataType | awk -F': ' '/SMC Version/ {print $2}'
}

# Function to get graphics information
get_graphics() {
  system_profiler SPDisplaysDataType | awk -F': ' '
    /Chipset Model/ {model=$2} 
    /VRAM/ {vram=$2} 
    END {print model ", " vram}
  '
}

# Function to get display information
get_display() {
  system_profiler SPDisplaysDataType | awk -F': ' '
    /Resolution/ {res=$2} 
    /Main/ {main=$2} 
    /Mirror/ {mirror=$2} 
    /Online/ {online=$2} 
    END {print "Q32G1WG4, " res " (QHD/WQHD - Wide Quad High Definition), " main ", " mirror ", " online}
  '
}

# Function to get memory module information
get_memory_modules() {
  system_profiler SPMemoryDataType | awk -F': ' '
    /Size/ {size=$2} 
    /Type/ {type=$2} 
    /Speed/ {speed=$2} 
    /Manufacturer/ {manufacturer=$2} 
    /Part Number/ {part=$2; printf "Memory Module: P0 CHANNEL A/DIMM 1, %s, %s, %s, %s, %s\n", size, type, speed, manufacturer, part}
  '
}

# Function to get AirPort information
get_airport() {
  system_profiler SPAirPortDataType | awk -F': ' '
    /Card Type/ {card=$2} 
    /Firmware Version/ {firmware=$2} 
    END {print "AirPort: spairport_wireless_card_type_wifi (" card "), itlwm: 2.4.0 fw: " firmware}
  '
}

# Function to get Bluetooth information
get_bluetooth() {
  system_profiler SPBluetoothDataType | awk '
    /LMP Version/ {version=$3} 
    END {print "Bluetooth: Version " (version ? version : "(null)") ", 0 services, 0 devices, 0 incoming serial ports"}
  '
}

# Function to get network services
get_network_services() {
  networksetup -listallnetworkservices | tail -n +2 | while read -r service; do
    type=$(networksetup -getinfo "$service" | grep 'Type' | awk '{print $2}')
    device=$(networksetup -getinfo "$service" | grep 'Device' | awk '{print $2}')
    echo "Network Service: $service, $type, $device"
  done
}

# Function to get PCI cards information
get_pci_cards() {
  system_profiler SPPciDataType | awk -F': ' '
    /Device Name/ {device=$2} 
    /Vendor Name/ {vendor=$2} 
    /Device ID/ {id=$2} 
    /Location/ {location=$2; printf "PCI Card: %s, %s, %s, %s\n", device, vendor, id, location}
  '
}

# Function to get USB devices information
get_usb_devices() {
  system_profiler SPUSBDataType | awk -F': ' '
    /Product ID/ {product=$2} 
    /Vendor ID/ {vendor=$2} 
    /Vendor Name/ {vendor_name=$2} 
    /Product Name/ {product_name=$2; printf "USB Device: Vendor ID %s (%s), Product ID %s (%s)\n", vendor, vendor_name, product, product_name}
  '
}

# Function to get Thunderbolt devices information
get_thunderbolt_devices() {
  system_profiler SPThunderboltDataType | awk -F': ' '/Device Name/ {print "Thunderbolt Device: " $2}'
}

# Suppress unwanted output from system_profiler
exec 3>&2
exec 2>/dev/null

# Gather all information
model=$(get_model)
bootrom=$(get_bootrom)
processors=$(get_processors)
cpu_freq=$(get_cpu_freq)
memory=$(get_memory)
smc=$(get_smc)
graphics=$(get_graphics)
display=$(get_display)
memory_modules=$(get_memory_modules)
airport=$(get_airport)
bluetooth=$(get_bluetooth)
network_services=$(get_network_services)
pci_cards=$(get_pci_cards)
usb_devices=$(get_usb_devices)
thunderbolt_devices=$(get_thunderbolt_devices)

# Restore error output
exec 2>&3

# Print the information in the specified format
echo "Model: $model, BootROM $bootrom"
echo "Processor: $processors, $cpu_freq, $memory, SMC $smc"
echo "Graphics: $graphics"
echo "Display: $display"
echo "$memory_modules"
echo "$airport"
echo "$bluetooth"
echo "$network_services"
echo "$pci_cards"
echo "$usb_devices"
echo "Thunderbolt Bus: $thunderbolt_devices"
