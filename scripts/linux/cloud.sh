#!/usr/bin/env bash
# Cloud CLIs: AWS, Google Cloud and Azure. Each one is optional.
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

setup_aws() {
  if has aws; then
    ok "AWS CLI already installed"
  else
    info "Installing AWS CLI v2"
    case $DISTRO in
      arch) pkg_install aws-cli-v2 ;;
      ubuntu)
        pkg_install curl unzip
        local tmp
        tmp=$(mktemp -d)
        curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "$tmp/awscliv2.zip"
        unzip -q "$tmp/awscliv2.zip" -d "$tmp"
        sudo "$tmp/aws/install"
        rm -rf "$tmp"
        ;;
    esac
  fi
  aws --version

  if confirm "Configure AWS credentials now?"; then
    local profile
    ask_required profile "Profile name" "default"
    if confirm "Does this account use SSO (IAM Identity Center)?" n; then
      aws configure sso --profile "$profile"
    else
      info "You will be asked for Access Key ID, Secret Access Key, region (e.g. us-east-1) and output (json)"
      aws configure --profile "$profile"
    fi
    aws sts get-caller-identity --profile "$profile" || warn "Credentials did not work; rerun this module."
  fi
}

setup_gcloud() {
  if has gcloud; then
    ok "gcloud already installed"
  else
    info "Installing Google Cloud CLI"
    case $DISTRO in
      arch)
        ensure_yay
        yay -S --needed --noconfirm google-cloud-cli
        ;;
      ubuntu)
        pkg_install apt-transport-https ca-certificates gnupg curl
        curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg |
          sudo gpg --dearmor --yes -o /usr/share/keyrings/cloud.google.gpg
        echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" |
          sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list >/dev/null
        apt_refresh
        pkg_install google-cloud-cli
        ;;
    esac
  fi
  gcloud --version

  if confirm "Run gcloud init (log in, choose project and region)?"; then
    gcloud init
  fi
  if confirm "Create application-default credentials (SDKs, Terraform)?" n; then
    gcloud auth application-default login
  fi
}

setup_azure() {
  if has az; then
    ok "Azure CLI already installed"
  else
    info "Installing Azure CLI"
    case $DISTRO in
      arch) pkg_install azure-cli ;;
      ubuntu) curl -fsSL https://aka.ms/InstallAzureCLIDeb | sudo bash ;;
    esac
  fi
  az version --output table || true

  if confirm "Log in to Azure now?"; then
    if confirm "Is this machine without a browser (use device code)?" n; then
      az login --use-device-code
    else
      az login
    fi
    az account show --output table
  fi
}

confirm "Set up AWS CLI?" n && setup_aws
confirm "Set up Google Cloud CLI?" n && setup_gcloud
confirm "Set up Azure CLI?" n && setup_azure

ok "Cloud CLIs setup done"
