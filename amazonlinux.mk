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

tar-dev-packages: install-python-packages install-vim-plug install-shfmt install-git-remote-s3
	tar zcvf /tmp/dev-packages.tar.gz -C /home/hadoop .local .vim .vimrc .bashrc
