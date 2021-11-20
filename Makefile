VERSION := $(shell git describe --tags)
LDFLAGS += -X "main.BuildTimestamp=$(shell date -u "+%Y-%m-%d %H:%M:%S")"
LDFLAGS += -X "main.airVersion=$(VERSION)"
LDFLAGS += -X "main.goVersion=$(shell go version | sed -r 's/go version go(.*)\ .*/\1/')"

.PHONY: demo
demo:
	@echo "hello" $(LDFLAGS)

.PHONY: build
build:
	go build -ldflags '$(LDFLAGS)'

.PHONY: install
install:
	@echo "Installing air..."
	go install -ldflags '$(LDFLAGS)'

.PHONY: release
release:
	GOOS=darwin GOARCH=amd64 go build -ldflags '$(LDFLAGS)' -o bin/darwin/air
	GOOS=linux GOARCH=amd64 go build -ldflags '$(LDFLAGS)' -o bin/linux/air
	GOOS=windows GOARCH=amd64 go build -ldflags '$(LDFLAGS)' -o bin/windows/air.exe

.PHONY: docker-image
docker-image:
	docker build -t aibotsoft/auto-play:$(VERSION) -f ./Dockerfile .

.PHONY: push-docker-image
push-docker-image:
	docker push aibotsoft/air:$(VERSION)