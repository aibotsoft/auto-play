USERNAME := $(shell git config user.name)
APPNAME := $(shell basename `git rev-parse --show-toplevel`)
VERSION := $(shell git describe --tags)
LDFLAGS += -X "main.BuildTimestamp=$(shell date -u "+%Y-%m-%d %H:%M:%S")"
LDFLAGS += -X "main.appVersion=$(VERSION)"
LDFLAGS += -X "main.goVersion=$(shell go version | sed -r 's/go version go(.*)\ .*/\1/')"

.PHONY: demo
demo:
	@echo "hello" $(APPNAME)

.PHONY: build
build:
	go build -ldflags '$(LDFLAGS)'

.PHONY: install
install:
	@echo "Installing..."
	go install -ldflags '$(LDFLAGS)'

.PHONY: release
release:
	GOOS=darwin GOARCH=amd64 go build -ldflags '$(LDFLAGS)' -o bin/darwin/$(APPNAME)
	GOOS=linux GOARCH=amd64 go build -ldflags '$(LDFLAGS)' -o bin/linux/$(APPNAME)
	GOOS=windows GOARCH=amd64 go build -ldflags '$(LDFLAGS)' -o bin/windows/$(APPNAME).exe

.PHONY: docker-image
docker-image:
	docker build -t $(USERNAME)/$(APPNAME):$(VERSION) -f ./Dockerfile .

.PHONY: push-docker-image
push-docker-image:
	docker push $(USERNAME)/$(APPNAME):$(VERSION)