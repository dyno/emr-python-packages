SHELL = /bin/bash

# as root
install-packages:
	# tar and make needs to be installed before anything else.
	yum install --assumeyes \
		cyrus-sasl-devel      \
		gcc                   \
		gcc-c++               \
		git-core              \
		go                    \
		gzip                  \
		make                  \
		python3               \
		python3-devel         \
		shadow-utils          \
		sudo                  \
		tar                   \
		util-linux            \
		vim                   \
		which                 \
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

install-shfmt:
	cp /tmp/bashrc ~/.bashrc
	GO111MODULE=on go get mvdan.cc/sh/v3/cmd/shfmt
	cp ~/go/bin/shfmt ~/.local/bin

install-git-remote-s3:
	# https://github.com/bgahagan/git-remote-s3/
	curl -LO https://github.com/bgahagan/git-remote-s3/releases/download/v0.1.2/git-remote-s3-x86_64-unknown-linux-gnu.gz
	gunzip git-remote-s3-x86_64-unknown-linux-gnu.gz
	mv git-remote-s3-x86_64-unknown-linux-gnu ~/.local/bin/git-remote-s3
	chmod +x ~/.local/bin/git-remote-s3

install-rg:
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep-12.1.1-x86_64-unknown-linux-musl.tar.gz
	tar xvf ripgrep-12.1.1-x86_64-unknown-linux-musl.tar.gz ripgrep-12.1.1-x86_64-unknown-linux-musl/rg
	tar xvf ripgrep-12.1.1-x86_64-unknown-linux-musl.tar.gz ripgrep-12.1.1-x86_64-unknown-linux-musl/complete/rg.bash
	cp ripgrep-12.1.1-x86_64-unknown-linux-musl/rg ~/.local/bin/
	chmod +x ~/.local/bin/rg
	cp ripgrep-12.1.1-x86_64-unknown-linux-musl/complete/rg.bash ~/.bash_completion.d/

install-fzf:
	curl -LO https://github.com/junegunn/fzf/releases/download/0.27.0/fzf-0.27.0-linux_amd64.tar.gz
	curl -L -o ~/.bash_completion.d/fzf.bash https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.bash
	curl -L -o ~/.bash_completion.d/fzf-key-bindings.bash https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.bash
	tar xvf fzf-0.27.0-linux_amd64.tar.gz
	mv fzf ~/.local/bin/fzf
	chmod +x ~/.local/bin/fzf

install-fd:
	curl -LO https://github.com/sharkdp/fd/releases/download/v8.2.1/fd-v8.2.1-x86_64-unknown-linux-musl.tar.gz
	tar xvf fd-v8.2.1-x86_64-unknown-linux-musl.tar.gz fd-v8.2.1-x86_64-unknown-linux-musl/autocomplete/fd.bash-completion
	tar xvf fd-v8.2.1-x86_64-unknown-linux-musl.tar.gz fd-v8.2.1-x86_64-unknown-linux-musl/fd
	cp fd-v8.2.1-x86_64-unknown-linux-musl/fd ~/.local/bin
	chmod +x ~/.local/bin/fd
	cp fd-v8.2.1-x86_64-unknown-linux-musl/autocomplete/fd.bash-completion ~/.bash_completion.d/fd.bash

tar-dev-packages: install-python-packages install-vim-plug install-shfmt install-git-remote-s3 install-rg install-fzf install-fd
	tar zcvf /tmp/dev-packages.tar.gz -C /home/hadoop .local .vim .vimrc .bashrc .bash_completion.d
