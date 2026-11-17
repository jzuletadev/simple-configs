#!/usr/bin/env bash
# Docker Engine + Compose, service enabled, user added to the docker group.
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

if has docker; then
  ok "Docker already installed"
else
  info "Installing Docker"
  case $DISTRO in
    ubuntu)
      # shellcheck disable=SC1091
      . /etc/os-release
      # Ubuntu and its derivatives define UBUNTU_CODENAME; plain Debian does not.
      if [ -n "${UBUNTU_CODENAME:-}" ]; then
        base=ubuntu codename=$UBUNTU_CODENAME
      else
        base=debian codename=$VERSION_CODENAME
      fi
      pkg_install ca-certificates curl
      sudo install -m 0755 -d /etc/apt/keyrings
      sudo curl -fsSL "https://download.docker.com/linux/$base/gpg" -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$base $codename stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
      apt_refresh
      pkg_install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      ;;
    arch) pkg_install docker docker-compose docker-buildx ;;
  esac
fi

sudo systemctl enable --now docker.service

ME=$(id -un)
if getent group docker | grep -qw "$ME"; then
  ok "$ME is already in the docker group"
else
  sudo usermod -aG docker "$ME"
  warn "Added $ME to the docker group. Log out and back in to use docker without sudo."
fi

info "Checking the installation"
sudo docker run --rm hello-world >/dev/null && ok "hello-world container ran"
docker compose version

ok "Docker setup done"
