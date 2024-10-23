SHELL = /bin/bash

# where the repo is mounted
REPO := /mnt
PY := py311
ARCH := $(shell arch)

.DEFAULT_GOAL = tar-dev-packages

install-python-packages:
	cp $(REPO)/pyproject.$(PY).toml ./pyproject.toml
	uv sync
	[[ -e ~/.local ]] || mv ~/.venv ~/.local

install-vim-plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs                      \
	  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
	# END
	cp $(REPO)/vimrc ~/.vimrc
	vim -c ":PlugInstall" -c "qa"

GIT_REMOTE_S3_VERSION := 0.1.4
install-git-remote-s3:
	# https://github.com/bgahagan/git-remote-s3/
ifeq ($(ARCH),x86_64)
	curl -LO https://github.com/bgahagan/git-remote-s3/releases/download/v$(GIT_REMOTE_S3_VERSION)/git-remote-s3_v$(GIT_REMOTE_S3_VERSION)_x86_64-unknown-linux-musl.tar.gz
	tar zxvf git-remote-s3_v$(GIT_REMOTE_S3_VERSION)_x86_64-unknown-linux-musl.tar.gz
	mv git-remote-s3 ~/.local/bin/git-remote-s3
else ifeq ($(ARCH),aarch64)
	curl -LO https://github.com/bgahagan/git-remote-s3/archive/refs/tags/v$(GIT_REMOTE_S3_VERSION).tar.gz
	tar zxvf v$(GIT_REMOTE_S3_VERSION).tar.gz
	sudo yum -y install rust cargo
	cd git-remote-s3-$(GIT_REMOTE_S3_VERSION) && cargo install git-remote-s3
	cp ~/.cargo/bin/git-remote-s3 ~/.local/bin/
endif
	chmod +x ~/.local/bin/git-remote-s3

RG_VERSION := 14.1.1
install-rg:
	mkdir -p ~/.bash_completion.d
ifeq ($(ARCH),x86_64)
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/$(RG_VERSION)/ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl.tar.gz
	tar xvf ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl.tar.gz ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl/rg
	tar xvf ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl.tar.gz ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl/complete/rg.bash
	cp ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl/rg ~/.local/bin/
	cp ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl/complete/rg.bash ~/.bash_completion.d/
else ifeq ($(ARCH),aarch64)
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/$(RG_VERSION)/ripgrep-$(RG_VERSION)-aarch64-unknown-linux-gnu.tar.gz
	tar xvf ripgrep-$(RG_VERSION)-aarch64-unknown-linux-gnu.tar.gz ripgrep-$(RG_VERSION)-aarch64-unknown-linux-gnu/rg
	tar xvf ripgrep-$(RG_VERSION)-aarch64-unknown-linux-gnu.tar.gz ripgrep-$(RG_VERSION)-aarch64-unknown-linux-gnu/complete/rg.bash
	cp ripgrep-$(RG_VERSION)-aarch64-unknown-linux-gnu/rg ~/.local/bin/
	cp ripgrep-$(RG_VERSION)-aarch64-unknown-linux-gnu/complete/rg.bash ~/.bash_completion.d/
endif
	chmod +x ~/.local/bin/rg

FZF_VERSION := 0.55.0
install-fzf:
ifeq ($(ARCH),x86_64)
	curl -LO https://github.com/junegunn/fzf/releases/download/v$(FZF_VERSION)/fzf-$(FZF_VERSION)-linux_amd64.tar.gz
	tar xvf fzf-$(FZF_VERSION)-linux_amd64.tar.gz
else ifeq ($(ARCH),aarch64)
	curl -LO https://github.com/junegunn/fzf/releases/download/v$(FZF_VERSION)/fzf-$(FZF_VERSION)-linux_arm64.tar.gz
	tar xvf fzf-$(FZF_VERSION)-linux_arm64.tar.gz
endif
	mkdir -p ~/.bash_completion.d
	curl -L -o ~/.bash_completion.d/fzf.bash https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.bash
	curl -L -o ~/.bash_completion.d/fzf-key-bindings.bash https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.bash
	mv fzf ~/.local/bin/fzf
	chmod +x ~/.local/bin/fzf

tar-dev-packages: install-python-packages install-vim-plug install-git-remote-s3 install-rg install-fzf
	cp $(REPO)/bashrc ~/.bashrc
	# for invoke.bash and make.bash
	tar -C $(REPO)/.bash_completion.d/ -cf - . | tar -C ~/.bash_completion.d/ -xvf -
	tar --exclude='*.py[co]' --exclude='__pycache__' -zcvf $(REPO)/dev-packages-$(PY)-$(ARCH).tar.gz -C /home/hadoop .local .vim .vimrc .bashrc .bash_completion.d
