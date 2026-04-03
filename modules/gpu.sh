#!/usr/bin/env bash
set -euo pipefail

STATE_FILE=/run/nvidia-power/state
BUS="0000:01:00.0"   # Nvidia GPU

mkdir -p /run/nvidia-power /run/modprobe.d

blacklist_runtime() {
  cat > /run/modprobe.d/nvidia-runtime-blacklist.conf <<EOF
blacklist nvidia
blacklist nvidia_drm
blacklist nvidia_modeset
blacklist nvidia_uvm
EOF
}

unblacklist_runtime() {
  rm -f /run/modprobe.d/nvidia-runtime-blacklist.conf
}

unload_modules() {
  modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia 2>/dev/null || true
}

load_modules() {
  modprobe -i nvidia nvidia_uvm nvidia_modeset nvidia_drm
}

check_gpu_in_use() {
  if lsof /dev/nvidia* >/dev/null 2>&1; then
    echo "[gpu] ERROR: NVIDIA GPU is currently in use. Aborting."
    return 1
  fi
  return 0
}

check_external_monitor() {
  if command -v xrandr >/dev/null 2>&1; then
    ext_connected=$(xrandr --listmonitors | grep -v eDP || true)
    if [ -n "$ext_connected" ]; then
      echo "[gpu] WARNING: external monitors may go black!"
    fi
  fi
}

main() {
  cmd=${1:-}

  case "$cmd" in
    off)
      echo "[gpu] Disabling NVIDIA GPU"
      if ! check_gpu_in_use; then exit 1; fi
      check_external_monitor
      echo off > "$STATE_FILE"
      blacklist_runtime
      unload_modules
      if [ -e /sys/bus/pci/devices/$BUS/remove ]; then
        echo 1 > /sys/bus/pci/devices/$BUS/remove
      fi
      echo "[gpu] NVIDIA disabled"
      ;;

    on)
      echo "[gpu] Enabling NVIDIA GPU"
      echo on > "$STATE_FILE"
      unblacklist_runtime
      echo 1 > /sys/bus/pci/rescan
      sleep 1
      load_modules
      echo "[gpu] NVIDIA enabled"
      ;;

    status)
      echo "[gpu] Status:"
      echo "  Desired state: $(cat "$STATE_FILE" 2>/dev/null || echo unknown)"
      if [ -e /sys/bus/pci/devices/$BUS ]; then echo "  PCI device: present"; else echo "  PCI device: removed"; fi
      if lsmod | grep -q '^nvidia'; then echo "  Modules: loaded"; else echo "  Modules: not loaded"; fi
      if [ -f /run/modprobe.d/nvidia-runtime-blacklist.conf ]; then echo "  Runtime blacklist: active"; else echo "  Runtime blacklist: inactive"; fi
      ;;

    resume)
      state=$(cat "$STATE_FILE" 2>/dev/null || echo off)
      echo "[gpu] Resume hook - enforcing state: $state"
      if [ "$state" = "off" ]; then
        if ! check_gpu_in_use; then exit 0; fi
        check_external_monitor
        blacklist_runtime
        unload_modules
        if [ -e /sys/bus/pci/devices/$BUS/remove ]; then
          echo 1 > /sys/bus/pci/devices/$BUS/remove || true
        fi
      else
        unblacklist_runtime
        echo 1 > /sys/bus/pci/rescan || true
        sleep 1
        load_modules || true
      fi
      ;;

    *)
      echo "Usage: gpu [on|off|status|resume]"
      exit 1
      ;;
  esac
}

main "$@"
