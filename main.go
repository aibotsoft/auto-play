package main

import (
	"go.uber.org/zap"
)

var appVersion string
var goVersion string
var buildTimestamp string

func demo() int {
	return 1
}
func main() {
	log, err := zap.NewDevelopment()
	if err != nil {
		panic(err)
	}
	log.Info("hello",
		zap.String("appVersion", appVersion),
		zap.String("goVersion", goVersion),
		zap.String("buildTimestamp", buildTimestamp),
		)
}
