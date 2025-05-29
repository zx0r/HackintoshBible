#!/bin/bash

# Ultimate Hackintosh Component Checker
# Creates a detailed report of working components

# Color codes for better readability
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "🔍 Starting Hackintosh Component Check..."

# Function to check if component is working
check_component() {
    if [ "$2" == "true" ]; then
        echo -e "${GREEN}✓ $1 is working${NC}"
    else
        echo -e "${RED}✗ $1 is not working${NC}"
    fi
}

# CPU & Power Management
echo -e "\n${BLUE}=== CPU & Power Management ===${NC}"
cpu_info=$(sysctl -n machdep.cpu.brand_string)
echo "CPU Model: $cpu_info"
check_component "CPU Power Management" $(pmset -g | grep -q "AC Power" && echo true || echo false)

# Graphics
echo -e "\n${BLUE}=== Graphics ===${NC}"
gpu_info=$(system_profiler SPDisplaysDataType | grep "Chipset Model" | awk -F": " '{print $2}')
echo "GPU Model: $gpu_info"
check_component "Metal Support" $(system_profiler SPDisplaysDataType | grep -q "Metal" && echo true || echo false)
check_component "Hardware Acceleration" $(system_profiler SPDisplaysDataType | grep -q "Metal: Supported" && echo true || echo false)

# Audio
echo -e "\n${BLUE}=== Audio ===${NC}"
audio_info=$(system_profiler SPAudioDataType | grep "Output Source:" | awk -F": " '{print $2}')
check_component "Audio Output" $(system_profiler SPAudioDataType | grep -q "Output Source" && echo true || echo false)
check_component "Audio Input" $(system_profiler SPAudioDataType | grep -q "Input Source" && echo true || echo false)

# Network
echo -e "\n${BLUE}=== Network ===${NC}"
check_component "WiFi" $(networksetup -listallhardwareports | grep -q "Wi-Fi" && echo true || echo false)
check_component "Ethernet" $(networksetup -listallhardwareports | grep -q "Ethernet" && echo true || echo false)
check_component "Bluetooth" $(system_profiler SPBluetoothDataType | grep -q "State: On" && echo true || echo false)

# USB
echo -e "\n${BLUE}=== USB Ports ===${NC}"
check_component "USB 2.0" $(system_profiler SPUSBDataType | grep -q "Speed: Up to 480 Mb/sec" && echo true || echo false)
check_component "USB 3.0" $(system_profiler SPUSBDataType | grep -q "Speed: Up to 5 Gb/sec" && echo true || echo false)

# Storage
echo -e "\n${BLUE}=== Storage ===${NC}"
check_component "NVME Support" $(system_profiler SPNVMeDataType | grep -q "NVMe" && echo true || echo false)
check_component "TRIM Support" $(system_profiler SPNVMeDataType | grep -q "TRIM Support: Yes" && echo true || echo false)

# Sleep & Wake
echo -e "\n${BLUE}=== Power Management ===${NC}"
check_component "Sleep" $(pmset -g | grep -q "sleep" && echo true || echo false)
check_component "Hibernation" $(pmset -g | grep -q "hibernatemode" && echo true || echo false)

# iServices
echo -e "\n${BLUE}=== iServices ===${NC}"
check_component "iMessage" $(defaults read com.apple.iChat | grep -q "Accounts" && echo true || echo false)
check_component "FaceTime" $(defaults read com.apple.facetime | grep -q "Accounts" && echo true || echo false)
check_component "App Store" $(defaults read com.apple.appstore | grep -q "DeveloperID" && echo true || echo false)

# Additional Features
echo -e "\n${BLUE}=== Additional Features ===${NC}"
check_component "FileVault" $(fdesetup status | grep -q "On" && echo true || echo false)
check_component "Handoff" $(defaults read com.apple.assistant | grep -q "Handoff" && echo true || echo false)
check_component "AirDrop" $(defaults read com.apple.sharingd | grep -q "DiscoveryMode" && echo true || echo false)

# System Information
echo -e "\n${BLUE}=== System Information ===${NC}"
echo "macOS Version: $(sw_vers -productVersion)"
echo "System Model: $(sysctl -n hw.model)"
echo "Board ID: $(ioreg -l | grep -i board-id | head -n1 | awk '{print $4}' | sed 's/"//g')"
echo "Serial Number: $(system_profiler SPHardwareDataType | grep "Serial Number" | awk '{print $4}')"

# Generate Report
echo -e "\n${BLUE}=== Generating Report ===${NC}"
report_file="hackintosh_report_$(date +%Y%m%d_%H%M%S).txt"
system_profiler -detailLevel mini > "$report_file"
echo "Detailed report saved to: $report_file"

echo -e "\n✅ Check completed! Review the results above and the detailed report."
