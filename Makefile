SHELL = /bin/bash

NAMESPACE := default
POD := amazonlinux

deploy:
	kubectl apply -f amazonlinux.yaml

bash:
	kubectl exec -it --namespace $(NAMESPACE) $(POD) -- bash

exec-make:
	kubectl cp --namespace $(NAMESPACE) $(POD).mk $(POD):/tmp/Makefile
	kubectl cp --namespace $(NAMESPACE) pyproject.toml $(POD):/tmp/
	kubectl cp --namespace $(NAMESPACE) poetry.toml $(POD):/tmp/
	kubectl cp --namespace $(NAMESPACE) vimrc $(POD):/tmp/vimrc
	kubectl cp --namespace $(NAMESPACE) bashrc $(POD):/tmp/bashrc
	kubectl exec -it --namespace $(NAMESPACE) $(POD) -- bash -c 'make -C /tmp install-virtualenv create-hadoop-user'
	kubectl exec -it --namespace $(NAMESPACE) $(POD) -- bash -c 'sudo -S -u hadoop make -C /tmp tar-dev-packages'
	kubectl cp --namespace $(NAMESPACE) $(POD):/tmp/dev-packages.tar.gz ./dev-packages.tar.gz
