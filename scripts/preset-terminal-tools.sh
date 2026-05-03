#!/bin/bash
set -e
#=================================================
# File name: preset-terminal-tools.sh
# System Required: Linux
# Version: 1.0
# Lisence: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================
mkdir -p files/root
pushd files/root

## Install oh-my-zsh
# Clone oh-my-zsh repository
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh ./.oh-my-zsh

# Install extra plugins
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ./.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ./.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-completions ./.oh-my-zsh/custom/plugins/zsh-completions

# Get .zshrc dotfile
cp "$GITHUB_WORKSPACE/scripts/.zshrc" .

popd

# Preload oh-my-zsh completion cache after boot so SSH logins stay fast.
mkdir -p files/etc/init.d files/etc/rc.d
cat > files/etc/init.d/zsh-preload <<'EOF'
#!/bin/sh /etc/rc.common

START=99

start() {
	(
		sleep 20
		[ -x /usr/bin/zsh ] || exit 0
		[ -r /root/.zshrc ] || exit 0
		HOME=/root USER=root SHELL=/usr/bin/zsh /usr/bin/zsh -i -c exit >/tmp/zsh-preload.log 2>&1
	) &
}
EOF
chmod 755 files/etc/init.d/zsh-preload
ln -sf ../init.d/zsh-preload files/etc/rc.d/S99zsh-preload
