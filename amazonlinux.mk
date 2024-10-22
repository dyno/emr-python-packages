SHELL = /bin/bash

# where the repo is mounted
REPO := /mnt


install-python-packages:
	cp $(REPO)/pyproject.toml ./
	uv sync
	mv ~/.venv ~/.local

install-vim-plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs                      \
	  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
	# END
	cp $(REPO)/vimrc ~/.vimrc
	vim -c ":PlugInstall" -c "qa"

GIT_REMOTE_S3_VERSION := 0.1.4
install-git-remote-s3:
	# https://github.com/bgahagan/git-remote-s3/
	curl -LO https://github.com/bgahagan/git-remote-s3/releases/download/v0.1.4/git-remote-s3_v0.1.4_x86_64-unknown-linux-musl.tar.gz
	tar zxvf git-remote-s3_v0.1.4_x86_64-unknown-linux-musl.tar.gz
	mv git-remote-s3 ~/.local/bin/git-remote-s3
	chmod +x ~/.local/bin/git-remote-s3

RG_VERSION := 14.1.0
install-rg:
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/$(RG_VERSION)/ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl.tar.gz
	tar xvf ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl.tar.gz ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl/rg
	tar xvf ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl.tar.gz ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl/complete/rg.bash
	cp ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl/rg ~/.local/bin/
	chmod +x ~/.local/bin/rg
	mkdir -p ~/.bash_completion.d
	cp ripgrep-$(RG_VERSION)-x86_64-unknown-linux-musl/complete/rg.bash ~/.bash_completion.d/

FZF_VERSION := 0.54.3
install-fzf:
	curl -LO https://github.com/junegunn/fzf/releases/download/v$(FZF_VERSION)/fzf-$(FZF_VERSION)-linux_amd64.tar.gz
	mkdir -p ~/.bash_completion.d
	curl -L -o ~/.bash_completion.d/fzf.bash https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.bash
	curl -L -o ~/.bash_completion.d/fzf-key-bindings.bash https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.bash
	tar xvf fzf-$(FZF_VERSION)-linux_amd64.tar.gz
	mv fzf ~/.local/bin/fzf
	chmod +x ~/.local/bin/fzf

tar-dev-packages: install-python-packages install-vim-plug install-git-remote-s3 install-rg install-fzf
	cp $(REPO)/bashrc ~/.bashrc
	# for invoke.bash and make.bash
	tar -C $(REPO)/.bash_completion.d/ -cf - . | tar -C ~/.bash_completion.d/ -xvf -
	tar --exclude='*.py[co]' --exclude='__pycache__' -zcvf $(REPO)/dev-packages.tar.gz -C /home/hadoop .local .vim .vimrc .bashrc .bash_completion.d
