package main

import (
	"fmt"
	"os"

	"github.com/almaslennikov/reusable-release-workflows-testing/pkg/config"
	"github.com/almaslennikov/reusable-release-workflows-testing/pkg/server"
)

func main() {
	cfg := config.NewDefault()
	fmt.Printf("%s v%s starting...\n", config.AppName, cfg.Version)

	srv := server.New(cfg)
	if err := srv.Start(); err != nil {
		fmt.Fprintf(os.Stderr, "server error: %v\n", err)
		os.Exit(1)
	}
}
