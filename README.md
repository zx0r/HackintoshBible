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

#### Hackintosh BIOS Configuration Guide 

##### Critical BIOS Settings

###### Essential Changes

1. Disable I2C and ESPI
   
   - Path: Settings → AMD CBS → FCH Common Options
   - Purpose: Prevents random system freezes

2. PCIe Configuration
   - Set PCIe slot to Gen4 (if available)
   - Above 4G Decoding: Enabled
   - Resizable BAR Support: Auto/Enabled

3. Memory Settings

   - Enable X.M.P. profile
   - Verify 3600MHz configuration

4. Security Settings

   - Disable Trusted Computing
   - Disable Wake on LAN
   - Disable Boot over LAN

5. USB Configuration
   - Enable XHCI Hand-off
   - USB configuration via SSDT (OC 0.8.5+)

###### Additional Settings

- HPET: Enabled
- CSM Support: Disabled
- Power Loading: Enabled (Platform Power settings)
- Configure custom fan profiles

###### Disable the Following Settings:

1. **Secure Boot**
   - **Reason**: Restricts unsigned OS and driver loading.
   - **Action**: Disable to allow macOS boot.

2. **Fast Boot**
   - **Reason**: Skips essential hardware checks, causing macOS installation issues.
   - **Action**: Disable for better compatibility.

3. **Compatibility Support Module (CSM)**
   - **Reason**: macOS requires UEFI mode. CSM can cause GPU errors (e.g., gIO stalls).
   - **Action**: Disable to ensure UEFI mode is active.

4. **Serial/COM Port**
   - **Reason**: Often unused and may conflict with macOS.
   - **Action**: Disable.

5. **Parallel Port**
   - **Reason**: Rarely used in modern setups and may cause macOS issues.
   - **Action**: Disable.

6. **VT-d (Virtualization Technology for Directed I/O)**
   - **Reason**: Can conflict with macOS unless `DisableIoMapper` is set to `YES` in OpenCore.
   - **Action**: Disable unless explicitly configured in OpenCore.

7. **Thunderbolt**
   - **Reason**: Can cause issues during macOS installation if not configured properly.
   - **Action**: Temporarily disable; re-enable after macOS is installed if needed.

8. **Intel SGX**
   - **Reason**: Not required for macOS and can interfere with installation.
   - **Action**: Disable.

9. **Intel Platform Trust (PTT)**
   - **Reason**: Interferes with macOS; unnecessary for Hackintosh.
   - **Action**: Disable.

10. **CFG Lock (MSR 0xE2 write protection)**
    - **Reason**: Must be off for macOS to boot. If unavailable in BIOS:
      - Use `AppleCpuPmCfgLock` under `Kernel → Quirks` in OpenCore.
    - **Action**: Disable or use OpenCore configuration.

---

##### Additional Notes:
- Ensure BIOS is updated to the latest stable version for your motherboard.
- Save your BIOS configuration after changes for backup purposes.
- If CFG Lock cannot be disabled, ensure the OpenCore configuration handles this quirk.
- Re-enable specific features like Thunderbolt only after macOS is installed and stable.

**Pro Tip**: Double-check all settings before booting the macOS installer to avoid errors.

