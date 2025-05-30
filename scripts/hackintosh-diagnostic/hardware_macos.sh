#!/bin/bash

# Fetch system overview
system_info=$(system_profiler SPHardwareDataType | awk -F': ' \
  '/Model Identifier/ {model=$2} /Boot ROM Version/ {bootrom=$2} \
    /Total Number of Cores/ {cpu=$2" cores"} /Processor Name/ {proc=$2} \
    /Processor Speed/ {speed=$2} /Memory:/ {ram=$2} \
    END {print "Model: " model ", BootROM " bootrom ", " cpu ", " proc ", " speed ", " ram}')

echo "$system_info"

# Fetch Graphics Info
graphics_info=$(system_profiler SPDisplaysDataType | awk -F': ' \
  '/Chipset Model:/ {gpu=$2} /VRAM \(Total\)/ {vram=$2} \
    END {print "Graphics: " gpu ", " vram}')

echo "$graphics_info"

# Fetch Display Info
display_info=$(system_profiler SPDisplaysDataType | awk -F': ' \
  '/Resolution:/ {res=$2} /Main Display: Yes/ {main="Main"} /Mirror:/ {mirror=$2} /Online: Yes/ {online="Online"} \
    END {print "Display: " res ", " main ", Mirror" mirror ", " online}')

echo "$display_info"

# Fetch Memory Modules
memory_modules=$(system_profiler SPMemoryDataType | awk -F': ' \
  '/Size:/ {size=$2} /Type:/ {type=$2} /Speed:/ {speed=$2} /Manufacturer:/ {manufacturer=$2} /Part Number:/ {part=$2} \
    END {print "Memory Module: " size ", " type ", " speed ", " manufacturer ", " part}')

echo "$memory_modules"

# Fetch Network Info
network_info=$(system_profiler SPNetworkDataType | awk -F': ' \
  '/Service:/ {service=$2} /Type:/ {type=$2} /BSD Device Name:/ {device=$2} \
    END {print "Network Service: " service ", " type ", " device}')

echo "$network_info"

# Fetch PCI Devices
pci_info=$(system_profiler SPPCIDataType | awk -F': ' \
  '/Device Name:/ {device=$2} /Vendor Name:/ {vendor=$2} /Slot:/ {slot=$2} \
    END {print "PCI Card: " device ", " vendor ", " slot}')

echo "$pci_info"

# Fetch USB Devices
usb_info=$(system_profiler SPUSBDataType | awk -F': ' \
  '/Product ID:/ {product=$2} /Vendor ID:/ {vendor=$2} /Speed:/ {speed=$2} \
    END {print "USB Device: " product ", " vendor ", " speed}')

echo "$usb_info"

# Fetch loaded kexts
kext_info=$(kextstat | awk '{print $6}' | tail -n +2)
echo "Kernel Extensions:"
echo "$kext_info"

# Debug Information
echo "System Logs:"
log show --predicate 'subsystem == "com.apple.driverkit"' --info --last 1h

# # Define output file
# OUTPUT_FILE="system_info.txt"

# # Fetch system overview
# echo "System Overview:" >$OUTPUT_FILE
# system_profiler SPHardwareDataType >>$OUTPUT_FILE
# echo "" >>$OUTPUT_FILE

# # Fetch detailed hardware information
# echo "Hardware Information:" >>$OUTPUT_FILE
# system_profiler SPHardwareDataType -detailLevel full >>$OUTPUT_FILE
# echo "" >>$OUTPUT_FILE

# # Fetch kext information
# echo "Kext Information:" >>$OUTPUT_FILE
# kextstat >>$OUTPUT_FILE
# echo "" >>$OUTPUT_FILE

# # Fetch system profiler data for various hardware components
# echo "Graphics/Displays Information:" >>$OUTPUT_FILE
# system_profiler SPDisplaysDataType >>$OUTPUT_FILE
# echo "" >>$OUTPUT_FILE

# echo "Memory Information:" >>$OUTPUT_FILE
# system_profiler SPMemoryDataType >>$OUTPUT_FILE
# echo "" >>$OUTPUT_FILE

# echo "Network Information:" >>$OUTPUT_FILE
# system_profiler SPNetworkDataType >>$OUTPUT_FILE
# echo "" >>$OUTPUT_FILE

# echo "PCI Information:" >>$OUTPUT_FILE
# system_profiler SPPCIDATAType >>$OUTPUT_FILE
# echo "" >>$OUTPUT_FILE

# echo "USB Device Information:" >>$OUTPUT_FILE
# system_profiler SPUSBDataType >>$OUTPUT_FILE
# echo "" >>$OUTPUT_FILE

# echo "Thunderbolt Device Information:" >>$OUTPUT_FILE
# system_profiler SPThunderboltDataType >>$OUTPUT_FILE
# echo "" >>$OUTPUT_FILE

# # Fetch other debug information
# echo "Other Debug Information:" >>$OUTPUT_FILE
# echo "AirPort Information:" >>$OUTPUT_FILE
# system_profiler SPAirPortDataType >>$OUTPUT_FILE
# echo "" >>$OUTPUT_FILE

# echo "Bluetooth Information:" >>$OUTPUT_FILE
# system_profiler SPBluetoothDataType >>$OUTPUT_FILE
# echo "" >>$OUTPUT_FILE

# echo "Software Information:" >>$OUTPUT_FILE
# system_profiler SPSoftwareDataType >>$OUTPUT_FILE
# echo "" >>$OUTPUT_FILE

# # Notify user
# echo "System information has been collected in $OUTPUT_FILE"
