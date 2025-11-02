#!/usr/bin/env bash

set +e
clear

LOGFILE="$HOME/termux-super-installer.log"
: > "$LOGFILE"

ts(){ date '+%Y-%m-%d %H:%M:%S'; }
log(){ printf "[%s] %s\n" "$(ts)" "$*" | tee -a "$LOGFILE"; }

# helper para ejecutar comando mostrando salida y registrando resultado
run(){
  DESC="$1"; shift
  log "=== EJECUTANDO: $DESC ==="
  echo "--- Salida de: $DESC ---" | tee -a "$LOGFILE"
  "$@" 2>&1 | tee -a "$LOGFILE"
  RC=${PIPESTATUS[0]:-$?}
  if [ $RC -ne 0 ]; then
    log "!!! FALLÓ ($RC): $DESC"
  else
    log "+++ OK: $DESC"
  fi
  echo "-------------------------------" | tee -a "$LOGFILE"
  sleep 0.2
}

# comprobación entorno Termux
if ! command -v pkg >/dev/null 2>&1 ; then
  log "ERROR: 'pkg' no encontrado. Ejecuta esto en Termux."
  exit 1
fi

# Variables para apt-get no interactivo (evitan prompts; NO silencian salida)
export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none

log "INICIO: Termux Super Installer (visible) - $(ts)"
echo ""
# Pregunta inicial
while true; do
  read -p "¿Deseas continuar con la ejecución del instalador masivo? [y/N]: " RESP
  case "$RESP" in
    [Yy]* ) break;;
    [Nn]*|"" )
      log "Operación cancelada por el usuario. Saliendo."
      exit 0;;
    * ) echo "Responde y (sí) o n (no)." ;;
  esac
done

# Instalar lolcat para banner (si hace falta)
# lolcat requiere ruby gem "lolcat". Instalamos ruby si no existe y gem lolcat.
if ! command -v lolcat >/dev/null 2>&1 ; then
  log "lolcat no encontrado. Instalando ruby + gem lolcat (visible)"
  run "pkg install -y ruby" pkg install -y ruby
  # gem instalará lolcat (sin ocultar)
  run "gem install lolcat --no-document" gem install lolcat --no-document
fi

# Mostrar banner con lolcat (si está disponible). Si no, mostrar banner simple.
if command -v lolcat >/dev/null 2>&1 ; then
  # si figlet no existe, usar echo
  if ! command -v figlet >/dev/null 2>&1 ; then
    echo "========================================" | lolcat
    echo "   🚀  TERMUX SUPER INSTALLER  🚀" | lolcat
    echo "========================================" | lolcat
  else
    figlet -f slant "TERMUX SUPER" | lolcat
    figlet -f small "INSTALLER" | lolcat
  fi
else
  echo "========================================"
  echo "   🚀  TERMUX SUPER INSTALLER  🚀"
  echo "========================================"
fi

echo ""
log "Si quieres detener el script en cualquier momento, usa Ctrl+C."

# Pregunta sobre desinstalar paquetes
while true; do
  read -p "¿Quieres DESINSTALAR primero una lista de paquetes comunes (sí/no)? [y/N]: " UNR
  case "$UNR" in
    [Yy]* )
      # Lista de paquetes candidatos a desinstalar - revisar antes de ejecutar
      UNPACKS=(
        metasploit sqlmap hydra nikto masscan wpscan aircrack-ng
        # Añade/quita aquí según prefieras
      )
      echo ""
      echo "Se van a intentar desinstalar (si existen):"
      for p in "${UNPACKS[@]}"; do echo "  - $p"; done
      echo ""
      read -p "¿Confirmas que quieres continuar con la desinstalación de los anteriores? [y/N]: " CONFUN
      case "$CONFUN" in
        [Yy]* )
          for p in "${UNPACKS[@]}"; do
            run "pkg uninstall -y $p" pkg uninstall -y "$p" || true
          done
          break;;
        * )
          log "Desinstalación cancelada por el usuario."
          break;;
      esac
      ;;
    [Nn]*|"" )
      log "No se realizará desinstalación previa."
      break;;
    * ) echo "Responde y (sí) o n (no)." ;;
  esac
done

### ===== INSTALACIÓN MASIVA VISIBLE =====

# Actualizar sistema con pkg y con apt-get (si está presente)
run "pkg update -y" pkg update -y
run "pkg upgrade -y" pkg upgrade -y

# Si apt-get existe, actualizamos la lista también
if command -v apt-get >/dev/null 2>&1 ; then
  run "apt-get update -y" apt-get update -y
  run "apt-get upgrade -y" apt-get upgrade -y
fi

# Paquetes base (mostrar todos)
BASE_PACKAGES=(
  git curl wget openssh nano vim bash-completion coreutils
  tar unzip zip proot proot-distro termux-api util-linux
  clang make cmake build-essential pkg-config python python3 python3-dev
  ruby perl nodejs npm golang rust cargo openjdk-17
  jq htop tmux neofetch net-tools iproute2 iputils-ping dnsutils
  ncdu rsync findutils grep sed awk
)

log "Instalando paquetes base (cada instalación se mostrará):"
for p in "${BASE_PACKAGES[@]}"; do
  run "pkg install -y $p" pkg install -y "$p"
done

# apt-get extras (si existe)
if command -v apt-get >/dev/null 2>&1 ; then
  APT_PACKAGES=(
    build-essential default-jdk default-jre zlib1g-dev libssl-dev libffi-dev
    libbz2-dev libsqlite3-dev libreadline-dev
  )
  log "Instalando paquetes apt-get:"
  for p in "${APT_PACKAGES[@]}"; do
    run "apt-get install -y $p" apt-get install -y "$p"
  done
fi

# pip (usar python3 -m pip cuando sea posible)
if command -v python3 >/dev/null 2>&1 ; then
  PIP_CMD="python3 -m pip"
else
  PIP_CMD="pip"
fi

run "Actualizar pip y setuptools" $PIP_CMD install --upgrade pip setuptools wheel

PIP_PACKAGES=(
  requests beautifulsoup4 lxml pillow numpy pandas flask django
  paramiko scapy sqlmap pwntools mitmproxy colorama termcolor pyfiglet tqdm
)

log "Instalando paquetes pip (visibles):"
for pkg in "${PIP_PACKAGES[@]}"; do
  run "pip install $pkg" $PIP_CMD install "$pkg"
done

# npm global
if command -v npm >/dev/null 2>&1 ; thenCARGO_TOOLS=(ripgrep bat fd-find exa)
  log "Instalando herramientas via cargo (visibles):"
  for t in "${CARGO_TOOLS[@]}"; do
    run "cargo install $t" cargo install "$t"
  done
fi

# go tools (go install pkg@latest)
if command -v go >/dev/null 2>&1 ; then
  GO_TOOLS=(github.com/projectdiscovery/nuclei/v2/cmd/nuclei github.com/projectdiscovery/httpx/cmd/httpx)
  log "Instalando herramientas Go (visibles):"
  for g in "${GO_TOOLS[@]}"; do
    run "go install ${g}@latest" go install "${g}@latest"
  done
fi

# Lista amplia de paquetes pkg extra (se intentan todos)
EXTRA_PKGS=(
  nmap hydra john nikto sqlmap aircrack-ng wireshark tcpdump masscan
  netcat-openbsd whois smbclient openvpn tor torsocks proxychains-ng wifite wpscan
  seclists
)

log "Instalando paquetes extra con pkg (visibles):"
for p in "${EXTRA_PKGS[@]}"; do
  run "pkg install -y $p" pkg install -y "$p"
done

# Clonar repositorios educativos/famosos y ejecutar pasos básicos si aplica
REPOS=(
  "https://github.com/sqlmapproject/sqlmap.git"
  "https://github.com/rapid7/metasploit-framework.git"
  "https://github.com/robertdavidgraham/masscan.git"
  "https://github.com/mitmproxy/mitmproxy.git"
  "https://github.com/lanmaster53/recon-ng.git"
  "https://github.com/threat9/routersploit.git"
  "https://github.com/enaqx/awesome-pentest.git"
  "https://github.com/sullo/nikto.git"
  "https://github.com/wpscanteam/wpscan.git"
  "https://github.com/trustedsec/social-engineer-toolkit.git"
)

TOOLS_DIR="$HOME/termux-tools"
mkdir -p "$TOOLS_DIR"
log "Clonando repositorios en $TOOLS_DIR (si ya existen, intentará pull)"
else
    run "git clone $repo $dest" git clone "$repo" "$dest"
  fi

  # pasos básicos de instalación si existen
  if [ -f "$dest/setup.py" ]; then
    run "python3 setup.py install ($name)" bash -c "cd \"$dest\" && python3 setup.py install"
  fi
  if [ -f "$dest/requirements.txt" ]; then
    run "pip install -r requirements.txt ($name)" bash -c "cd \"$dest\" && $PIP_CMD install -r requirements.txt"
  fi
  if [ -f "$dest/Makefile" ]; then
    run "make && make install ($name)" bash -c "cd \"$dest\" && make && make install || true"
  fi
done

# Intento básico instalación Metasploit si se clonó (puede fallar en Termux)
if [ -d "$TOOLS_DIR/metasploit-framework" ]; then
  log "Intentando instalación básica de metasploit-framework (si es posible)"
  if command -v gem >/dev/null 2>&1 ; then
    run "gem install bundler --no-document" gem install bundler --no-document || true
    run "bundle install --without test" bash -c "cd \"$TOOLS_DIR/metasploit-framework\" && bundle install --without test || true"
  fi
fi

# proot-distro distros populares (opcional)
if command -v proot-distro >/dev/null 2>&1 ; then
  DISTROS=(ubuntu-20.04 debian-11 kali-rolling archlinux)
  log "Instalando distros con proot-distro (visibles): ${DISTROS[*]}"
  for d in "${DISTROS[@]}"; do
    run "proot-distro install $d" proot-distro install "$d"
  done
else
  log "proot-distro no está presente, se omiten instalaciones de distros."
fi

# Limpieza (visible) - usar apt-get autoremove en lugar de apt autoremove
log "Intentando limpieza: pkg autoremove y apt-get autoremove (si aplica)"
run "pkg autoremove -y" pkg autoremove -y || true
if command -v apt-get >/dev/null 2>&1 ; then
  run "apt-get autoremove -y" apt-get autoremove -y || true
fi

# Resumen final visible
echo
log "=== RESUMEN FINAL (ejemplos de comandos instalados si están presentes) ==="
for cmd in git python3 pip3 npm node nmap sqlmap msfconsole nuclei httpx; do
  if command -v $cmd >/dev/null 2>&1 ; then
    echo " - $cmd -> $(command -v $cmd)"
  fi
done

log "FIN del script. Revisa $LOGFILE para la salida completa: $LOGFILE"
echo "Fecha fin: $(ts)"
