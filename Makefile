.PHONY: run build login push latest test save

CV ?= 4.7.0
DIST ?= fedora
WORKDIR=/mnt/$$(basename $$(pwd))

run: build test login push

build:
	docker build --build-arg OPENCV_VERSION=$(CV) -t dkimg/opencv:$(CV)-$(DIST) ./$(DIST)

push:
	@docker tag dkimg/opencv:$(CV)-$(DIST) ghcr.io/dkimg/opencv:$(CV)-$(DIST)
	@docker tag dkimg/opencv:$(CV)-$(DIST) quay.io/dkimg/opencv:$(CV)-$(DIST)
	@docker push dkimg/opencv:$(CV)-$(DIST)
	@docker push ghcr.io/dkimg/opencv:$(CV)-$(DIST)
	@docker push quay.io/dkimg/opencv:$(CV)-$(DIST)

latest:
	@docker pull dkimg/opencv:$(CV)-$(DIST)
	@docker tag dkimg/opencv:$(CV)-$(DIST) dkimg/opencv:latest
	@docker tag dkimg/opencv:$(CV)-$(DIST) ghcr.io/dkimg/opencv:latest
	@docker tag dkimg/opencv:$(CV)-$(DIST) quay.io/dkimg/opencv:latest
	@docker push dkimg/opencv:latest
	@docker push ghcr.io/dkimg/opencv:latest
	@docker push quay.io/dkimg/opencv:latest

test:
	@docker run --rm -v $$(pwd):$(WORKDIR) -w $(WORKDIR) dkimg/opencv:$(CV)-$(DIST) python3 test.py

save:
	@docker save dkimg/opencv:$(CV)-$(DIST) | gzip > dkimg_opencv$(CV)-$(DIST).tar.gz
