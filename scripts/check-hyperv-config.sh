#!/bin/bash

set -euo pipefail

OPENWRTROOT="${1:-$PWD}"
MODE="${2:-auto}"

required_target_fragment=(
  CONFIG_HYPERV=y
  CONFIG_HYPERVISOR_GUEST=y
  CONFIG_HYPERV_NET=y
  CONFIG_HYPERV_STORAGE=y
  CONFIG_HYPERV_UTILS=y
  CONFIG_HYPERV_VMBUS=y
  CONFIG_PCI_HYPERV=y
  CONFIG_PCI_MMCONFIG=y
  CONFIG_SCSI_FC_ATTRS=y
)

required_kernel=(
  CONFIG_HYPERV=y
  CONFIG_HYPERVISOR_GUEST=y
  CONFIG_HYPERV_NET=y
  CONFIG_HYPERV_STORAGE=y
  CONFIG_HYPERV_UTILS=y
  CONFIG_HYPERV_VMBUS=y
  CONFIG_PCI_HYPERV=y
  CONFIG_PCI_MMCONFIG=y
  CONFIG_SCSI_FC_ATTRS=y
)

check_config_file() {
  local file="$1"
  shift
  local -a required=("$@")
  local missing=0

  echo "Checking $(realpath "$file")"
  for key in "${required[@]}"; do
    if grep -Fxq "$key" "$file"; then
      echo "  OK  $key"
    else
      echo "  MISS $key"
      missing=1
    fi
  done

  return "$missing"
}

find_kernel_config() {
  find "$OPENWRTROOT/build_dir" -path '*/linux-*/linux-*/.config' 2>/dev/null | head -n 1
}

status=0

if [[ "$MODE" == "auto" || "$MODE" == "top" ]]; then
  target_fragment="$OPENWRTROOT/target/linux/x86/64/config-6.18"
  if [[ -f "$target_fragment" ]]; then
    check_config_file "$target_fragment" "${required_target_fragment[@]}" || status=1
  else
    echo "Target kernel fragment not found: $target_fragment"
    status=1
  fi
fi

if [[ "$MODE" == "auto" || "$MODE" == "kernel" ]]; then
  kernel_config="$(find_kernel_config || true)"
  if [[ -n "${kernel_config:-}" && -f "$kernel_config" ]]; then
    check_config_file "$kernel_config" "${required_kernel[@]}" || status=1
  else
    echo "Kernel .config not found under $OPENWRTROOT/build_dir yet"
    if [[ "$MODE" == "kernel" ]]; then
      status=1
    fi
  fi
fi

exit "$status"
