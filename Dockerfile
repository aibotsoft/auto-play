#FROM golang:1.17
#
#ENV GOPATH /go
#ENV GO111MODULE on
#
#COPY . /go/src/github.com/aibotsoft/auto-play
#WORKDIR /go/src/github.com/aibotsoft/auto-play
#RUN make install
#
#ENTRYPOINT ["/go/bin/auto-play"]

# STAGE 1: building the executable
FROM golang:alpine AS build

# git required for go mod
RUN apk add --no-cache git

# Working directory will be created if it does not exist
WORKDIR /src

# We use go modules; copy go.mod and go.sum
COPY ./go.mod ./go.sum ./
RUN go mod download

# Import code
COPY ./ ./

# Build the executable
RUN CGO_ENABLED=0 go build -ldflags="-w -s" -o /app main.go

# STAGE 2: build the container to run
FROM gcr.io/distroless/static AS final

# copy compiled app
COPY --from=build /app /app

# run binary
ENTRYPOINT ["/app"]