# ⚙️ ST-INSTALL

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
```

## 🔧 Installation & Usage

Clone this repository:
```bash
git clone https://github.com/k1itllx1killx/ST-INSTALL
```

# Move into the project folder:

```bash
cd ST-INSTALL && chmod +× *
```

# 1️⃣ Pre-installation Phase

Run the preinstall.py script to verify and prepare your environment:

```bash
python3 preinstall.py
```

# 2️⃣ Main Installation

Once pre-installation is complete, launch the main installer:
```bash
bash install.sh
```
or
```bash
./install.sh
```

# 🗂️ Project Structure

ST-INSTALLER/
│
├── preinstall.py     # Prepares and checks environment
├── install.sh        # Installs dependencies and tools
└── README.md         # This file

# ⚠️ Notes
•	If any package fails to install, check your Termux permissions:
 `termux-setup-storage`
==============≈================================================================

 •	Do not run as root unless explicitly required.
 •	Scripts are optimized for Termux default paths.

⸻

## 👤 Author

GitHub: `@k1itllx1killx`
Developed to automate setup environments for Termux power users.

⸻

# 🌟 Support & Contribution

• Pull requests and improvements are welcome.
• If you like this tool, give it a ⭐ on GitHub — it helps more than you think.
