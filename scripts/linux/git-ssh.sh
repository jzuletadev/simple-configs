#!/usr/bin/env bash
# Git identity, SSH key, GitHub connection and SSH host aliases.
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

case $DISTRO in
  ubuntu) has git && has ssh-keygen || pkg_install git openssh-client ;;
  arch) has git && has ssh-keygen || pkg_install git openssh ;;
esac

# --- Git -------------------------------------------------------------------
info "Git identity"
ask_required GIT_NAME "Full name" "$(git config --global user.name || true)"
while true; do
  ask_required GIT_EMAIL "Email" "$(git config --global user.email || true)"
  [[ $GIT_EMAIL =~ ^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$ ]] && break
  warn "That does not look like an email."
done

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.autocrlf input
ok "Git configured for $GIT_NAME <$GIT_EMAIL>"

# --- SSH key ---------------------------------------------------------------
KEY="$HOME/.ssh/id_ed25519"
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"

if [ -f "$KEY" ]; then
  ok "SSH key already exists: $KEY"
elif confirm "Generate an SSH key (ed25519) for $GIT_EMAIL?"; then
  info "ssh-keygen will ask for an optional passphrase"
  ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$KEY"
fi

if [ -f "$KEY.pub" ]; then
  chmod 600 "$KEY"

  # --- GitHub ----------------------------------------------------------------
  if ! has gh && confirm "Install GitHub CLI (gh) to log in and upload the key?"; then
    case $DISTRO in
      ubuntu)
        # GitHub's own repo: the distro package is too old for some flags used below.
        pkg_install curl
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg |
          sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
        sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" |
          sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
        apt_refresh
        pkg_install gh
        ;;
      arch) pkg_install github-cli ;;
    esac
  fi

  if has gh && confirm "Upload the public key to GitHub with gh?"; then
    if gh auth status >/dev/null 2>&1; then
      gh auth refresh -h github.com -s admin:public_key
    else
      gh auth login -h github.com -p ssh -w -s admin:public_key --skip-ssh-key
    fi
    gh ssh-key add "$KEY.pub" --title "$(hostname)" ||
      warn "Upload failed (the key may already be on GitHub)."
    # Lets git use gh's login for HTTPS remotes too.
    gh auth setup-git
  else
    if copy_to_clipboard <"$KEY.pub"; then
      ok "Public key copied to the clipboard"
    else
      cat "$KEY.pub"
    fi
    info "Paste it at https://github.com/settings/ssh/new"
    read -r -p "Press Enter when done..."
  fi

  info "Testing the GitHub connection"
  ssh -T -o StrictHostKeyChecking=accept-new git@github.com || true
fi

# --- SSH host aliases --------------------------------------------------------
CONFIG="$HOME/.ssh/config"
while confirm "Add an SSH host alias (e.g. a server or EC2) to ~/.ssh/config?" n; do
  ask_required ALIAS "Alias (what you type after ssh)"
  if [ -f "$CONFIG" ] && grep -qE "^Host[[:space:]]+$ALIAS\$" "$CONFIG"; then
    warn "Host $ALIAS already exists in $CONFIG"
    continue
  fi
  ask_required HOSTNAME_ "HostName (IP or DNS)"
  ask_required SSH_USER "User" "$(id -un)"
  ask_required IDENTITY "IdentityFile" "~/.ssh/id_ed25519"

  printf '\nHost %s\n    HostName %s\n    User %s\n    IdentityFile %s\n' \
    "$ALIAS" "$HOSTNAME_" "$SSH_USER" "$IDENTITY" >>"$CONFIG"
  chmod 600 "$CONFIG"

  IDENTITY_PATH="${IDENTITY/#\~/$HOME}"
  if [[ $IDENTITY_PATH == *.pem ]] && [ -f "$IDENTITY_PATH" ]; then
    chmod 400 "$IDENTITY_PATH"
  fi
  ok "Connect with: ssh $ALIAS"
done

ok "Git and SSH setup done"
