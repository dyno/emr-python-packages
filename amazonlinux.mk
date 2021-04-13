SHELL = /bin/bash

install-packages:
	# tar and make needs to be installed before anything else.
	yum install --assumeyes \
		cyrus-sasl-devel      \
		gcc                   \
		gcc-c++               \
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

create-hadoop-user:
	# same as on EMR
	id hadoop || { groupadd --gid 1001 hadoop && useradd --uid 1001 --gid 1001 --home-dir /home/hadoop hadoop; }
	echo 'hadoop ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/hadoop

# as root
install-virtualenv: install-packages
	pip3 install --upgrade pip
	/usr/local/bin/pip3 install --user poetry
	[[ ! -f /tmp/requirements.txt ]] && ~/.local/bin/poetry install --no-root || ~/.local/bin/poetry update
	~/.local/bin/poetry export --dev -f requirements.txt --output requirements.txt

# as hadoop
install-python-packages:
	/usr/local/bin/pip3 install --user -r /tmp/requirements.txt

tar-python-packages:
	tar zcvf /tmp/python3-user-packages.tar.gz -C /home/hadoop .local
