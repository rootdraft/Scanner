# Advanced Global DNS Scanner 🚀

A professional Bash-based network utility designed to scan global and local DNS servers, measure latency, and retrieve organizational metadata. This tool provides a high-level overview of DNS performance and security origins.

## 🤖 AI Contribution Disclaimer
**Note:** This project was developed as a collaboration between a human lead and AI. The core logic and script structure were generated and refined by **Google Gemini (AI)** based on specific functional requirements and network scanning logic provided by the user.

## ✨ Features
- **Comprehensive DNS List:** Pre-configured with major global providers (Google, Cloudflare, OpenDNS, etc.).
- **Real-time Latency Analysis:** Calculates network response time for each server.
- **Organization Lookup:** Integrates WHOIS data to identify the ISP or Entity owning the IP.
- **Custom Range Scanning:** Support for user-defined network segments and IP ranges.
- **Universal Linux Compatibility:** Designed to run on any standard Linux environment.
- **Result Exporting:** Save your scan reports into formatted text files for later analysis.

## 📋 Prerequisites
To ensure all features (DNS resolution and WHOIS lookups) function correctly, install the following dependencies based on your package manager:

### For Debian/Ubuntu:
```bash
sudo apt update
sudo apt install bash bind9-host whois util-linux

For Arch Linux:
sudo pacman -S bash bind whois util-linux
