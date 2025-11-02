# ⚙️ ST-INSTALLER

**ST-INSTALLER** is a powerful and automated dependency installer built for **Termux**.  
It’s designed to streamline the setup of multiple packages and tools with just a few commands.  
The installation process runs in two main phases:

1. **`preinstall.py`** – checks and prepares your environment.  
2. **`install.sh`** – performs the full dependency installation.  

---

## 🚀 Features
- ✅ Automated installation of multiple dependencies  
- ⚡ Environment and permission checks before setup  
- 🧩 Modular two-step process (Pre-install + Main install)  
- 💻 Fully compatible with **Termux**  

---

## 🧠 Requirements
Before you start, make sure you have the following:

- **Updated Termux**
- **Python 3**
- **Storage permission enabled**

Update your environment first:

```bash
pkg update && pkg upgrade -y
pkg install python git -y
termux-setup-storage

# 🔧 Installation & Usage

Clone this repository:
```bash
git clone https://github.com/k1itllx1killx/ST-INSTALLER
