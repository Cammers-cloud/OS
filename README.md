# Custom Micro-NT Gaming OS for GitHub Codespaces

An ultra-stripped, high-performance 64-bit NT-kernel environment designed to run natively inside a Linux Codespace and execute Roblox while evading heavy telemetry and desktop UI bloat.

## 🚀 How to Launch

1. Create a GitHub Codespace from this repository.
2. Ensure you have injected your compiled, micro-NT raw disk image (`micro_nt_kernel.img`) containing the `windows_config` scripts into the root folder.
3. Open a Codespaces terminal and execute the master boot controller:
   ```bash
   ./scripts/codespaces_boot.sh
   ```
4. A notification prompt will appear in the bottom right corner of GitHub Codespaces stating **"Port 6080 forwarded"**. 
5. Click **"Open in Browser"** to load the custom desktop display streaming directly from your bare-bones, ultra-fast kernel workspace.
