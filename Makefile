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
	kubectl exec -it --namespace $(NAMESPACE) $(POD) -- bash -c 'make -C /tmp install-virtualenv create-hadoop-user'
	kubectl exec -it --namespace $(NAMESPACE) $(POD) -- bash -c 'sudo -S -u hadoop make -C /tmp install-python-packages tar-python-packages'
	kubectl cp --namespace $(NAMESPACE) $(POD):/tmp/python3-user-packages.tar.gz ./python3-user-packages.tar.gz
