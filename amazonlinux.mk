SHELL = /bin/bash

# where the repo is mounted
REPO := /mnt
PY := py311
ARCH := $(shell arch)

.DEFAULT_GOAL = tar-dev-packages

HOME_LOCAL := ~/.local
ifeq ($(PY),py311)
UV := UV_NATIVE_TLS=true UV_SYSTEM_PYTHON=true UV_PROJECT_ENVIRONMENT=$(HOME_LOCAL) uv
UV_INSTALL_PYTHON :=
UV_UNINSTALL_PYTHON :=
else ifeq ($(PY),py310)
UV := UV_NATIVE_TLS=true UV_PROJECT_ENVIRONMENT=$(HOME_LOCAL) uv
UV_INSTALL_PYTHON := $(UV) python install 3.10.15
UV_UNINSTALL_PYTHON := $(UV) python uninstall 3.10.15
else ifeq ($(PY),py39)
UV := UV_NATIVE_TLS=true UV_SYSTEM_PYTHON=true UV_PROJECT_ENVIRONMENT=$(HOME_LOCAL) uv
UV_INSTALL_PYTHON :=
UV_UNINSTALL_PYTHON :=
else ifeq ($(PY),py37)
UV := UV_NATIVE_TLS=true UV_SYSTEM_PYTHON=true UV_PROJECT_ENVIRONMENT=$(HOME_LOCAL) uv
UV_INSTALL_PYTHON :=
UV_UNINSTALL_PYTHON :=
endif

install-python-packages:
	$(UV_INSTALL_PYTHON)
	$(UV) venv --allow-existing $(HOME_LOCAL)
	cp $(REPO)/pyproject.$(PY).toml ./pyproject.toml
	$(UV) sync
	$(UV_UNINSTALL_PYTHON)

install-vim-plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs                      \
	  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
	# END
	cp $(REPO)/vimrc ~/.vimrc
	vim -c ":PlugInstall" -c "qa!"

GIT_REMOTE_S3_VERSION := 0.2.1
install-git-remote-s3:
	# https://github.com/dyno/git-remote-s3/
ifeq ($(ARCH),x86_64)
	curl -LO https://github.com/dyno/git-remote-s3/releases/download/v$(GIT_REMOTE_S3_VERSION)/git-remote-s3-x86_64-unknown-linux-musl.tar.gz
	tar zxvf git-remote-s3-x86_64-unknown-linux-musl.tar.gz
	mv git-remote-s3 ~/.local/bin/git-remote-s3
else ifeq ($(ARCH),aarch64)
	curl -LO https://github.com/dyno/git-remote-s3/releases/download/v$(GIT_REMOTE_S3_VERSION)/git-remote-s3-aarch64-unknown-linux-musl.tar.gz
	tar zxvf git-remote-s3-aarch64-unknown-linux-musl.tar.gz
	cp git-remote-s3 ~/.local/bin/git-remote-s3
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
