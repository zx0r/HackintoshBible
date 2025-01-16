##### OpenCore Resources

- [OpenCore](https://dortania.github.io)
  - OpenCore documentation
  - Installation guides
  - Troubleshooting guides

##### Hackintosh Forums

- [amd-osx](https://amd-osx.com)
- [olarila](https://olarila.com)
- [tonymacx86](https://tonymacx86.com)
- [insanelymac](https://insanelymac.com)
- [elitemacx86](https://elitemacx86.com)
- [xda-developers](https://www.xda-developers.com/how-install-macos-virtualbox/)
- [hackintosh.com](https://hackintosh.com/)
- [hackintosh.org](https://hackintosh.org/index.php)
- [hackintosh-de](https://www.hackintosh-forum.de/forum/board/279-anleitungen-und-builds/)
- [macos86-it](https://macos86.it/)

##### Reddit Communities

- [r/hackintosh](https://www.reddit.com/r/hackintosh/)
- [r/Ryzentosh](https://www.reddit.com/r/Ryzentosh/)

##### Discord Servers

- Hackintosh Paradise
- AMD-OSX Discord

##### GitHub Resources

- [acidanthera](github.com/acidanthera)
- [AMD-OSX](github.com/AMD-OSX)

##### Telegram Groups

- Hackintosh Worldwide
- Ryzentosh Support
- Hackintosh Updates

#### 🚀 Hackintosh BIOS Configuration Guide

##### 🔧 Critical BIOS Settings

###### ✨ Essential Changes

1. **Peripheral management**

   - **I2C and ESPI**: ❌ Disabled
   - **Path**: `Settings → AMD CBS → FCH Common Options`
   - **Purpose**: 🛡️ Prevents random system freezes  
     <br>

2. **PCIe Configuration**

   - **Above 4G Decoding**: ✅ Enabled
   - **Resizable BAR Support**: Auto/Enabled
   - **PCIe Slot**: set Gen4 (if available)
     <br>

3. **Memory Settings**

   - **X.M.P. Profile**: ✅ Enabled
   - **Verify**: ⚡ 3600MHz configuration  
     <br>

4. **Security Settings**

   - **Secure Boot**: Trusted Computing ❌ Disable
   - **Wake on LAN**: ❌ Disable
   - **Boot over LAN**: ❌ Disable
     <br>

5. **USB Configuration**
   - XHCI Hand-off ✅ Enabled
   - **USB Configuration**: ⚙️ Managed via SSDT (OC 0.8.5+)

---

###### 💡 Additional Settings

- **HPET**: ✅ Enabled
- **CSM Support**: ❌ Disabled
- **Power Loading**: 🔋 Enabled (Platform Power settings)
- Configure custom 🌀 **fan profiles**

---

###### ❌ Disable the Following Settings:

1. **Secure Boot**

   - **Reason**: 🛑 Restricts unsigned OS and driver loading.
   - **Action**: ❌ Disable to allow macOS boot.  
     <br>

2. **Fast Boot**

   - **Reason**: 🚀 Skips essential hardware checks, causing macOS issues.
   - **Action**: ❌ Disable for better compatibility.  
     <br>

3. **Compatibility Support Module (CSM)**

   - **Reason**: 🖥️ macOS requires UEFI mode. CSM can cause GPU errors (e.g., gIO stalls).
   - **Action**: ❌ Disable to ensure UEFI mode is active.  
     <br>

4. **Serial/COM Port**

   - **Reason**: 🌀 Often unused and may conflict with macOS.
   - **Action**: ❌ Disable.  
     <br>

5. **Parallel Port**

   - **Reason**: 🔗 Rarely used in modern setups and may cause macOS issues.
   - **Action**: ❌ Disable.  
     <br>

6. **VT-d (Virtualization Technology for Directed I/O)**

   - **Reason**: ⚠️ Conflicts with macOS unless `DisableIoMapper` is set to `YES` in OpenCore.
   - **Action**: ❌ Disable unless explicitly configured in OpenCore.  
     <br>

7. **Thunderbolt**

   - **Reason**: ⚡ Can cause issues during macOS installation if not configured properly.
   - **Action**: ❌ Temporarily disable; re-enable after installation if needed.  
     <br>

8. **Intel SGX**

   - **Reason**: ⚙️ Not required for macOS and can interfere with installation.
   - **Action**: ❌ Disable.  
     <br>

9. **Intel Platform Trust (PTT)**

   - **Reason**: 🔒 Interferes with macOS; unnecessary for Hackintosh.
   - **Action**: ❌ Disable.  
     <br>

10. **CFG Lock (MSR 0xE2 write protection)**
    - **Reason**: ⚙️ Must be off for macOS to boot.
      - If unavailable in BIOS:
        - Use `AppleCpuPmCfgLock` under `Kernel → Quirks` in OpenCore.
    - **Action**: ❌ Disable or use OpenCore configuration.

---

##### 📘 Additional Notes:

- 📥 Ensure BIOS is updated to the latest stable version for your motherboard.
- 💾 Save your BIOS configuration after changes for backup purposes.
- ⚙️ If CFG Lock cannot be disabled, ensure OpenCore configuration handles this quirk.
- 🔄 Re-enable specific features like Thunderbolt only after macOS is installed and stable.

**💡 Pro Tip**: Double-check all settings before booting the macOS installer to avoid errors.

---

##### Debugging Notes

1. LAN Fix (if needed):

```bash
sudo ifconfig en0 media 1000baseT mediaopt full-duplex
```
