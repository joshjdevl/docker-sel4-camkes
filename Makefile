DOCKER ?= docker
IMAGE_NAME ?= sel4-camkes-build
TAG_NAME ?= tools
MAINTAINER ?= ikuz
CONTAINER_NAME ?= sel4-camkes-build

.PHONY: build pull create start

build: Dockerfile
	$(DOCKER) build -t $(IMAGE_NAME) .

pull:
	$(DOCKER) pull $(MAINTAINER)/$(IMAGE_NAME):$(TAG_NAME)
	$(DOCKER) tag $(MAINTAINER)/$(IMAGE_NAME):$(TAG_NAME) $(IMAGE_NAME)

create:
	$(DOCKER) create -it \
					 --name $(CONTAINER_NAME) \
					 $(IMAGE_NAME)

create_local:
	$(DOCKER) create -v $(SRC_PATH):/build_src \
					 -it \
					 --name $(CONTAINER_NAME) \
					 $(IMAGE_NAME)

start:
	$(DOCKER) start -ai $(CONTAINER_NAME)

rm:
	$(DOCKER) rm $(CONTAINER_NAME)
