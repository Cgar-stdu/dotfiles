#!/bin/bash

# Path to your dotfiles repo
DOTFILES="$HOME/dotfiles/.config"
SSHCONFIG="$HOME/dotfiles/.ssh/config"

# List of recommended config folders to symlink
CONFIGS=(
  alacritty
  btop
  code
  copyq
  eza
  fastfetch
  fcitx
  fcitx5
  fontconfig
  git
  gtk-3.0
  gtk-4.0
  jetbrains
  kitty
  lazygit
  mako
  nvim
  waybar
  yay
)

# Link bashrc
if [ -f ~/dotfiles/.bashrc ]; then
  rm -f ~/.bashrc
  ln -s ~/dotfiles/.bashrc ~/.bashrc
fi

echo "🔗 Linking config folders from $DOTFILES to ~/.config..."

for folder in "${CONFIGS[@]}"; do
  SRC="$DOTFILES/$folder"
  DEST="$HOME/.config/$folder"

  if [ -d "$SRC" ]; then
    if [ -e "$DEST" ] || [ -L "$DEST" ]; then
      echo "⚠️ Removing existing $DEST"

      # Try a normal removal first
      rm -rf "$DEST" 2>/dev/null

      # If it's still there, it failed (likely permissions) — retry with sudo
      if [ -e "$DEST" ] || [ -L "$DEST" ]; then
        echo "🔒 Normal removal failed for $DEST — retrying with sudo"
        sudo rm -rf "$DEST"
      fi
    fi

    # By this point DEST should be gone one way or another
    if [ -e "$DEST" ] || [ -L "$DEST" ]; then
      echo "🛑 Could not remove $DEST even with sudo — skipping $folder"
      continue
    fi

    echo "✅ Linking $folder"
    ln -s "$SRC" "$DEST"
  else
    echo "❌ Skipping $folder (not found in dotfiles)"
  fi
done

#link the hypr config
echo "Copy pasting the hypr config folder"
cp -r $DOTFILES/hypr $HOME/.config/

# Link SSH config
echo "🔐 Linking SSH config..."
mkdir -p "$HOME/.ssh"
if [ -f "$SSHCONFIG" ]; then
  if [ -L "$HOME/.ssh/config" ] || [ -f "$HOME/.ssh/config" ]; then
    echo "⚠️ Removing existing ~/.ssh/config"
    rm -f "$HOME/.ssh/config"
  fi
  ln -s "$SSHCONFIG" "$HOME/.ssh/config"
  chmod 600 "$HOME/.ssh/config"
  echo "✅ SSH config linked"
else
  echo "❌ SSH config not found in dotfiles"
fi

# Link back the theme for lazyvim with the Omarchy theme
ln -sf ~/.local/state/omarchy/current/theme/neovim.lua ~/.config/nvim/lua/plugins/theme.lua

###########################
# btop theme linking block
###########################

# Find Omarchy active theme dir (prefers ~/.config/omarchy/themes/current if it exists)
OM_THEME_DIR=""
if [ -L "$HOME/.config/omarchy/themes/current" ]; then
  OM_THEME_DIR="$(readlink -f "$HOME/.config/omarchy/themes/current")"
elif [ -d "$HOME/.local/share/omarchy/themes" ]; then
  # fallback: if only local share exists, try to pick first theme (user can adjust)
  OM_THEME_DIR="$(ls -1d "$HOME/.local/share/omarchy/themes"/* 2>/dev/null | head -n1)"
fi

if [ -n "$OM_THEME_DIR" ] && [ -f "$OM_THEME_DIR/btop.theme" ]; then
  echo "🔎 Found Omarchy btop.theme at: $OM_THEME_DIR/btop.theme"

  # Ensure btop user themes dir exists
  mkdir -p "$HOME/.config/btop/themes"

  # Create symlink for btop to find (named current.theme so your btop.conf can use "current")
  ln -snf "$OM_THEME_DIR/btop.theme" "$HOME/.config/btop/themes/current.theme"
  echo "🔗 Linked btop theme to ~/.config/btop/themes/current.theme"

  # Update ~/.config/btop/btop.conf to reference the 'current' theme name (safe sed)
  BTOP_CONF="$HOME/.config/btop/btop.conf"
  if [ -f "$BTOP_CONF" ]; then
    sed -i 's/^color_theme = .*$/color_theme = "current"/' "$BTOP_CONF" || true
    echo "✏️ Updated $BTOP_CONF to use color_theme = \"current\""
  else
    echo "⚠️ No btop config found at $BTOP_CONF — created ~/.config/btop/themes/current.theme only"
  fi

else
  echo "⚠️ Could not locate Omarchy btop.theme automatically."
  echo "   Expected file: <theme-dir>/btop.theme"
  echo "   Checked: $HOME/.config/omarchy/themes/current and $HOME/.local/share/omarchy/themes/*"
  echo "   If you know the path, run these commands manually:"
  echo "     mkdir -p ~/.config/btop/themes"
  echo "     ln -snf /path/to/omarchy/theme/btop.theme ~/.config/btop/themes/current.theme"
fi

###########################

# Minimal, non-destructive block to always ensure btop reads the active Omarchy btop.theme
# This block only creates the single symlink in ~/.config/btop/themes and does not remove or modify other config links.
{
  mkdir -p "$HOME/.config/btop/themes"

  OM_BTOP_THEME="$HOME/.local/state/omarchy/current/theme/btop.theme"
  if [ -f "$OM_BTOP_THEME" ]; then
    ln -snf "$OM_BTOP_THEME" "$HOME/.config/btop/themes/current.theme"
    echo "🔁 Ensured btop is linked to active Omarchy btop.theme -> ~/.config/btop/themes/current.theme"
  else
    echo "ℹ️ No $OM_BTOP_THEME found at runtime; skipping ensured link"
  fi
}

echo "🎉 All configs linked!"

