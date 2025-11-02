#!/usr/bin/env python3
import os
import subprocess
import time

# Colores
RESET = "\033[0m"

# Banner de presentación en lolcat
def banner():
    banner_text = """
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                                                  ┃
┃        ⚡🔥  ST-INSTALL TOOL SETUP  🔥⚡         ┃
┃                                                  ┃
┃           🌐 Install dependencies  🌐            ┃
┃                                                  ┃
┃  Created by: k1itllx1killx                       ┃
┃  Version: 1.1                                    ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
"""
    try:
        subprocess.run(f"echo '{banner_text}' | lolcat", shell=True)
    except:
        print(banner_text)

# Instalación de dependencias
def install_dependencies():
    print("\nInstalling dependencies...\n")
    os.system("pkg update && pkg upgrade")
    time.sleep(1)
    os.system("apt update && apt upgrade")
    time.sleep(1)
    os.system("pkg install python")                                                                                                     time.sleep(1)
    os.system("pkg install python3-pip")
    time.sleep(1)
    os.system("pip install --upgrade pip")
    time.sleep(1)
    os.system("pip install requests")
    time.sleep(1)
    os.system("gem install lolcat || pkg install lolcat")
    time.sleep(1)
    os.system("pkg install git")
    time.sleep(1)
    os.system("pkg install nano")
    time.sleep(1)
    os.system("pkg install curl")
    time.sleep(1)
    os.system("pkg install wget")                                                                                                       time.sleep(1)
    os.system("pkg install unzip")
    time.sleep(1)
    os.system("pkg install tar")
    time.sleep(1)
    os.system("pkg install nmap")
    time.sleep(1)
    os.system("pkg install gzip")
    time.sleep(1.5)
    print("\nDependencies installed successfully!\n")

# Main
def main():
    os.system("clear")
    banner()

    # Preguntar si instalar dependencias
    choice = input("Do you want to install dependencies? (y/n): ").strip().lower()
    if choice == "y":
        install_dependencies()
    else:
        print("Skipping dependencies installation...\n")

    print("Setup finished! 🎉")
    print("You can now run your install.sh")

if __name__ == "__main__":
    main()
