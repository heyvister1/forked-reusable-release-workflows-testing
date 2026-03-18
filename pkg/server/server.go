package server

import (
	"fmt"
	"net/http"

	"github.com/almaslennikov/reusable-release-workflows-testing/pkg/config"
)

// Server represents the HTTP server.
type Server struct {
	cfg *config.Config
}

// New creates a new Server with the given config.
func New(cfg *config.Config) *Server {
	return &Server{cfg: cfg}
}

// Start starts the HTTP server.
func (s *Server) Start() error {
	addr := fmt.Sprintf(":%d", s.cfg.Port)
	fmt.Printf("Starting %s server on %s (version %s)\n", config.AppName, addr, s.cfg.Version)

	http.HandleFunc("/healthz", s.healthHandler)
	return http.ListenAndServe(addr, nil)
}

func (s *Server) healthHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	fmt.Fprintln(w, "ok")
}
