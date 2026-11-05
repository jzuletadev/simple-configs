# Git and GitHub Configuration (via SSH)

This guide details the steps needed to configure your local environment and connect it securely to GitHub using SSH keys. This will allow you to `commit` and `push` without having to type your password every time.

## 1. Configure your local identity

First, you need to tell Git who you are. This information will be attached to every *commit* you make. Open your terminal and run:

```bash
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
```

Optional, but recommended: Set `main` as the default branch name for your new projects:

```bash
git config --global init.defaultBranch main
```

## 2. Generate your SSH key

Let's create a new cryptographic key using the ED25519 algorithm (highly secure and recommended):

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

> **Note:** When the system asks where to save the key and if you want a passphrase, you can simply press `Enter` on all options to leave the default values (no extra password).

## 3. Start the SSH agent and add the key

For your system to be able to use the newly created key, start the SSH agent in the background:

```bash
eval "$(ssh-agent -s)"
```

Add your private key to the agent:

```bash
ssh-add ~/.ssh/id_ed25519
```

## 4. Add the public key to GitHub

Now you need to copy the content of your **public** key and paste it into your GitHub account.

If you are using a Wayland environment (like Hyprland), you can copy it directly to your clipboard with:

```bash
cat ~/.ssh/id_ed25519.pub | wl-copy
```

*(If you don't have `wl-copy`, you can open the file with `nano ~/.ssh/id_ed25519.pub` or `cat` and copy the text manually).*

**On GitHub:**

1. Go to your GitHub account in your web browser.
2. Navigate to **Settings** > **SSH and GPG keys**.
3. Click the green **New SSH key** button.
4. Write a descriptive title (e.g., "My Linux PC") in the *Title* field.
5. Paste your key into the *Key* field.
6. Click **Add SSH key**.

## 5. Verify the connection

Finally, verify that your computer is communicating correctly with GitHub:

```bash
ssh -T git@github.com
```

If everything is correct, you will see a message similar to this:

> *"Hi [your_username]! You've successfully authenticated, but GitHub does not provide shell access."*

## Quick Alternative (GitHub CLI)

If you prefer to automate this entire process, you can use the official GitHub command-line tool (`gh`):

1. Install the package (example using an AUR helper on Arch Linux):

```bash
paru -S github-cli
```

2. Start the login process:

```bash
gh auth login
```

3. Select **GitHub.com**, then **SSH**, and follow the on-screen instructions to authorize your computer from the browser. The tool will take care of generating and uploading the keys automatically.
