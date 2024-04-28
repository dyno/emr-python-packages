SHELL = /bin/bash

# as root
install-packages:
	# tar and make needs to be installed before anything else.
	yum install --assumeyes \
		bzip2-devel           \
		cyrus-sasl-devel      \
		gcc                   \
		gcc-c++               \
		git-core              \
		go                    \
		gzip                  \
		libffi-devel          \
		make                  \
		openssl11-devel       \
		python3               \
		python3-devel         \
		readline-devel        \
		shadow-utils          \
		sqlite-devel          \
		sudo                  \
		tar                   \
		util-linux            \
		vim                   \
		which                 \
		xz-devel              \
		zlib-devel            \
		zstd                  \
	# END

install-virtualenv: install-packages
	pip3 install --upgrade pip
	/usr/local/bin/pip3 install --user poetry
	[[ ! -f /tmp/requirements.txt ]] && ~/.local/bin/poetry install --no-root || ~/.local/bin/poetry update
	~/.local/bin/poetry export --dev -f requirements.txt --output requirements.txt

create-hadoop-user:
	# same as on EMR
	id hadoop || { groupadd --gid 1001 hadoop && useradd --uid 1001 --gid 1001 --home-dir /home/hadoop hadoop; }
	echo 'hadoop ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/hadoop


# ------------------------------------------------------------------------------
# as hadoop

install-python-packages:
	/usr/local/bin/pip3 install --user -r /tmp/requirements.txt

install-vim-plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs                      \
	  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
	# END
	cp /tmp/vimrc ~/.vimrc
	vim -c ":PlugInstall" -c "qa"
	cp -r /tmp/.bash_completion.d ~/.bash_completion.d

install-git-remote-s3:
	# https://github.com/bgahagan/git-remote-s3/
	curl -LO https://github.com/bgahagan/git-remote-s3/releases/download/v0.1.4/git-remote-s3_v0.1.4_x86_64-unknown-linux-musl.tar.gz
	tar zxvf git-remote-s3_v0.1.4_x86_64-unknown-linux-musl.tar.gz
	mv git-remote-s3 ~/.local/bin/git-remote-s3
	chmod +x ~/.local/bin/git-remote-s3

RG_VERSION := 13.0.0
install-rg:
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/$(RG_VERSION)/ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl.tar.gz
	tar xvf ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl.tar.gz ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl/rg
	tar xvf ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl.tar.gz ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl/complete/rg.bash
	cp ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl/rg ~/.local/bin/
	chmod +x ~/.local/bin/rg
	cp ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl/complete/rg.bash ~/.bash_completion.d/

FZF_VERSION := 0.33.0
install-fzf:
	curl -LO https://github.com/junegunn/fzf/releases/download/$(FZF_VERSION)/fzf-$(FZF_VERSION)-linux_amd64.tar.gz
	curl -L -o ~/.bash_completion.d/fzf.bash https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.bash
	curl -L -o ~/.bash_completion.d/fzf-key-bindings.bash https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.bash
	tar xvf fzf-$(FZF_VERSION)-linux_amd64.tar.gz
	mv fzf ~/.local/bin/fzf
	chmod +x ~/.local/bin/fzf

tar-dev-packages: install-python-packages install-vim-plug install-git-remote-s3 install-rg install-fzf
	cp /tmp/bashrc ~/.bashrc
	tar --exclude='*.py[co]' --exclude='__pycache__' -zcvf /tmp/dev-packages.tar.gz -C /home/hadoop .local .vim .vimrc .bashrc .bash_completion.d
