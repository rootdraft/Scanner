# Advanced Global DNS Scanner 🚀

A professional Bash-based network utility designed to scan global and local DNS servers, measure latency, and retrieve organizational metadata.

## 🤖 AI Contribution Disclaimer
**Note:** This project was developed as a collaboration between a human lead and AI. The core logic and script structure were generated and refined by **Google Gemini (AI)** based on specific functional requirements.

## ✨ Features
- **Comprehensive DNS List:** Pre-configured with major global providers.
- **Real-time Latency Analysis:** Calculates network response time.
- **Organization Lookup:** Integrates WHOIS data.
- **Universal Linux Compatibility:** Runs on any standard Linux environment.

## 📋 Prerequisites
### For Debian/Ubuntu:
\`\`\`bash
sudo apt update
sudo apt install bash bind9-host whois util-linux
\`\`\`

### For Arch Linux:
\`\`\`bash
sudo pacman -S bash bind whois util-linux
\`\`\`

## 🚀 Installation & Usage
1. **Clone & Run:**
\`\`\`bash
git clone git@github.com:rootdraft/scanner.git
cd scanner
chmod +x scanner.sh
./scanner.sh
\`\`\`
