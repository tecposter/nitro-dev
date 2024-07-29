#!/usr/bin/make

CUR_DIR = $(PWD)
# CUR_UID = $(shell id -u)
# CUR_UID = $(echo $UID)

image:
	docker build -t nitro-local -f ./Dockerfile .

container:
	docker run -it -d --rm --name nitro-local \
		-u zjh:docker \
  	-e PATH="$$HOME/.cargo/bin:$$PATH" \
		-e NITRO_CLI_LOGS_PATH="$$HOME/var/log/nitro_enclaves" \
		-e NITRO_CLI_BLOBS="$$HOME/aws-nitro-enclaves-cli/blobs/x86_64" \
		-e NITRO_CLI_INSTALL_DIR="$$HOME/nitro-cli" \
		-v ${CUR_DIR}/:/home/zjh \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-p 8000:8000 \
		nitro-local /bin/sh
