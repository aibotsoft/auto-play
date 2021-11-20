FROM golang:1.17

ENV GOPATH /go
ENV GO111MODULE on

COPY . /go/src/github.com/aibotsoft/auto-play
WORKDIR /go/src/github.com/aibotsoft/auto-play
RUN make install

ENTRYPOINT ["/go/bin/auto-play"]