#!/usr/bin/env bash
# Base system: update packages, install essentials, optional AUR helper on Arch.
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

info "Updating system packages ($DISTRO)"
pkg_upgrade

info "Installing essentials"
case $DISTRO in
  ubuntu) pkg_install git curl wget unzip zip ca-certificates gnupg build-essential ;;
  arch) pkg_install git curl wget unzip zip ca-certificates gnupg base-devel ;;
esac

if [ "$DISTRO" = arch ] && ! has yay && confirm "Install yay to use the AUR?"; then
  ensure_yay
fi

ok "Base setup done"
