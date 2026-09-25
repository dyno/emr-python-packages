SHELL = /bin/bash

# where the repo is mounted
REPO := /mnt
PY := py311
ARCH := $(shell arch)

.DEFAULT_GOAL = tar-dev-packages

HOME_LOCAL := ~/.local
ifeq ($(PY),py312)
UV := UV_NATIVE_TLS=true UV_PROJECT_ENVIRONMENT=$(HOME_LOCAL) uv
UV_INSTALL_PYTHON := $(UV) python install 3.12.13
UV_UNINSTALL_PYTHON := $(UV) python uninstall 3.12.13
else ifeq ($(PY),py311)
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

GIT_REMOTE_S3_VERSION := 0.2.2
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

FZF_VERSION := 0.74.4
install-fzf:
ifeq ($(ARCH),x86_64)
	curl -LO https://github.com/junegunn/fzf/releases/download/v$(FZF_VERSION)/fzf-$(FZF_VERSION)-linux_amd64.tar.gz
	tar xvf fzf-$(FZF_VERSION)-linux_amd64.tar.gz
else ifeq ($(ARCH),aarch64)
	curl -LO https://github.com/junegunn/fzf/releases/download/v$(FZF_VERSION)/fzf-$(FZF_VERSION)-linux_arm64.tar.gz
	tar xvf fzf-$(FZF_VERSION)-linux_arm64.tar.gz
endif
	mkdir -p ~/.bash_completion.d
	curl -L -o ~/.bash_completion.d/fzf.bash https://raw.githubusercontent.com/junegunn/fzf/v$(FZF_VERSION)/shell/completion.bash
	curl -L -o ~/.bash_completion.d/fzf-key-bindings.bash https://raw.githubusercontent.com/junegunn/fzf/v$(FZF_VERSION)/shell/key-bindings.bash
	mv fzf ~/.local/bin/fzf
	chmod +x ~/.local/bin/fzf

JQ_VERSION := 1.8.2
install-jq:
ifeq ($(ARCH),x86_64)
	curl -L -o ~/.local/bin/jq https://github.com/jqlang/jq/releases/download/jq-$(JQ_VERSION)/jq-linux-amd64
else ifeq ($(ARCH),aarch64)
	curl -L -o ~/.local/bin/jq https://github.com/jqlang/jq/releases/download/jq-$(JQ_VERSION)/jq-linux-arm64
endif
	chmod +x ~/.local/bin/jq

K9S_VERSION := 0.51.0
install-k9s:
ifeq ($(ARCH),x86_64)
	curl -LO https://github.com/derailed/k9s/releases/download/v$(K9S_VERSION)/k9s_Linux_amd64.tar.gz
	tar xvf k9s_Linux_amd64.tar.gz k9s
else ifeq ($(ARCH),aarch64)
	curl -LO https://github.com/derailed/k9s/releases/download/v$(K9S_VERSION)/k9s_Linux_arm64.tar.gz
	tar xvf k9s_Linux_arm64.tar.gz k9s
endif
	mv k9s ~/.local/bin/k9s
	chmod +x ~/.local/bin/k9s

KUBECTL_VERSION := 1.37.1
install-kubectl:
	mkdir -p ~/.bash_completion.d
ifeq ($(ARCH),x86_64)
	curl -L -o ~/.local/bin/kubectl https://dl.k8s.io/release/v$(KUBECTL_VERSION)/bin/linux/amd64/kubectl
else ifeq ($(ARCH),aarch64)
	curl -L -o ~/.local/bin/kubectl https://dl.k8s.io/release/v$(KUBECTL_VERSION)/bin/linux/arm64/kubectl
endif
	chmod +x ~/.local/bin/kubectl
	~/.local/bin/kubectl completion bash > ~/.bash_completion.d/kubectl.bash

# GNU make: built --without-guile so it links only libc (glibc 2.34, matching
# the AL2023 target), avoiding the libguile/libgc/... chain the OS make pulls in.
MAKE_VERSION := 4.4.1
install-make:
	curl -LO https://mirrors.kernel.org/gnu/make/make-$(MAKE_VERSION).tar.gz
	tar xzf make-$(MAKE_VERSION).tar.gz
	cd make-$(MAKE_VERSION) && ./configure --without-guile && make
	cp make-$(MAKE_VERSION)/make ~/.local/bin/make
	chmod +x ~/.local/bin/make

# GNU diffutils diff from the AL2023 build image links only libc (glibc 2.34),
# so it runs as-is on the AL2023 notebook target.
install-diff:
	cp /usr/bin/diff ~/.local/bin/diff
	chmod +x ~/.local/bin/diff

tar-dev-packages: install-python-packages install-vim-plug install-git-remote-s3 install-rg install-fzf install-jq install-k9s install-kubectl install-make install-diff
	cp $(REPO)/bashrc ~/.bashrc
	# for invoke.bash and make.bash
	tar -C $(REPO)/.bash_completion.d/ -cf - . | tar -C ~/.bash_completion.d/ -xvf -
	tar --exclude='*.py[co]' --exclude='__pycache__' -zcvf $(REPO)/dev-packages-$(PY)-$(ARCH).tar.gz -C /home/hadoop .local .vim .vimrc .bashrc .bash_completion.d
