package config

const (
	// AppName is the name of the application.
	AppName = "reusable-release-workflows-testing"

	// DefaultPort is the default port the application listens on.
	DefaultPort = 8080
)

// Config holds the application configuration.
type Config struct {
	Port    int
	Debug   bool
	Version string
}

// NewDefault returns a Config with default values.
func NewDefault() *Config {
	return &Config{
		Port:    DefaultPort,
		Debug:   false,
		Version: "0.0.1",
	}
}
