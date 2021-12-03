USERNAME := $(shell git config user.name)
APPNAME := $(shell basename `git rev-parse --show-toplevel`)
VERSION := $(shell git describe --tags)
GOVERSION := $(shell go version | sed -r 's/go version go(.*)\ .*/\1/')
BUILDTIMESTAMP := $(shell date -u "+%Y-%m-%d %H:%M:%S")
LDFLAGS = -w -s
LDFLAGS += -X "main.buildTimestamp=$(BUILDTIMESTAMP)"
LDFLAGS += -X "main.appVersion=$(VERSION)"
LDFLAGS += -X "main.goVersion=$(GOVERSION)"

demo:
	@echo "hello" $(APPNAME)

build:
	@echo "Building... " $(USERNAME):$(APPNAME):$(VERSION)
	go build -ldflags '$(LDFLAGS)'

test:
	go test  ./... -v -covermode=atomic -coverprofile=coverage.txt

install:
	@echo "Installing..."
	go install -ldflags '$(LDFLAGS)'

release:
	#GOOS=darwin GOARCH=amd64 go build -ldflags '$(LDFLAGS)' -o bin/darwin/$(APPNAME)
	GOOS=linux GOARCH=amd64 go build -ldflags '$(LDFLAGS)' -o bin/linux/$(APPNAME)
	GOOS=windows GOARCH=amd64 go build -ldflags '$(LDFLAGS)' -o bin/windows/$(APPNAME).exe
	ls -lh ./bin/linux
	ls -lh ./bin/windows

docker-build:
	docker build -t $(USERNAME)/$(APPNAME):$(VERSION) -f ./Dockerfile .

docker-push:
	docker push $(USERNAME)/$(APPNAME):$(VERSION)

docker-run:
	docker run --name $(APPNAME) --rm $(USERNAME)/$(APPNAME):$(VERSION)

.PHONY: docker-push docker-build release install test build demo
