package main

import (
	"bufio"
	"bytes"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strings"
)

type Config struct {
	Target string `json:"target"`
}

var (
	dryRun     bool
	uninstall  bool
	verbose    bool
	listOnly   bool
	showHelp   bool
	selected   []string
	homeDir    string
	configHome string
)

func init() {
	flag.BoolVar(&dryRun, "dry-run", false, "Show what would be stowed without doing it")
	flag.BoolVar(&dryRun, "n", false, "Alias for --dry-run")

	flag.BoolVar(&uninstall, "uninstall", false, "Unstow the specified apps")
	flag.BoolVar(&uninstall, "u", false, "Alias for --uninstall")

	flag.BoolVar(&verbose, "verbose", false, "Enable verbose output")
	flag.BoolVar(&verbose, "v", false, "Alias for --verbose")

	flag.BoolVar(&listOnly, "list", false, "List available apps")
	flag.BoolVar(&listOnly, "l", false, "Alias for --list")

	flag.BoolVar(&showHelp, "help", false, "Show this help message")
	flag.BoolVar(&showHelp, "h", false, "Alias for --help")
}

func usage() {
	fmt.Printf(`Usage: %s [OPTIONS] [APP...]

Options:
  -h, --help      Show this help message
  -n, --dry-run   Show what would be stowed without actually doing it
  -u, --uninstall Unstow the specified apps
  -v, --verbose   Enable verbose output
  -l, --list      List all available apps

Examples:
  %[1]s                # Stow all apps
  %[1]s fish vim       # Stow only fish and vim
  %[1]s -n fish        # Dry run stowing fish
  %[1]s -u fish        # Unstow fish
  %[1]s -l             # List all available apps
`, os.Args[0])
}

func main() {
	flag.Parse()
	selected = flag.Args()

	homeDir, _ = os.UserHomeDir()
	configHome = os.Getenv("XDG_CONFIG_HOME")
	if configHome == "" {
		configHome = filepath.Join(homeDir, ".config")
	}

	if showHelp {
		usage()
		os.Exit(0)
	}

	checkDependencies([]string{"stow", "git", "jq", "sway", "swaylock", "swayidle", "fish", "vim", "bash", "fastfetch", "alacritty", "mako", "waybar", "starship", "hyprpicker", "mpv", "eza", "wl-clipboard"})

	if listOnly {
		apps := getAllApps(".")
		fmt.Println("Available apps:")
		for _, app := range apps {
			fmt.Printf("  %s\n", app)
		}
		return
	}

	initSubmodules()

	if err := processApps(); err != nil {
		fmt.Println("\nCOMPLETED WITH ERRORS")
		os.Exit(1)
	}

	fmt.Println("\nALL DONE")
}

func isArchLinux() bool {
	_, err := exec.LookPath("pacman")
	return err == nil
}

func promptUser(message string) bool {
	fmt.Printf("%s [y/N]: ", message)
	reader := bufio.NewReader(os.Stdin)
	response, _ := reader.ReadString('\n')
	response = strings.TrimSpace(strings.ToLower(response))
	return response == "y" || response == "yes"
}

func installArchPackages(packages []string) error {
	args := []string{"pacman", "-S", "--needed", "--noconfirm"}
	args = append(args, packages...)

	cmd := exec.Command(args[0], args[1:]...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

func checkDependencies(cmds []string) {
	var missing []string
	for _, cmd := range cmds {
		if _, err := exec.LookPath(cmd); err != nil {
			missing = append(missing, cmd)
		}
	}
	if len(missing) == 0 {
		return
	}

	if isArchLinux() {
		fmt.Printf("Missing required dependencies: %s\n", strings.Join(missing, ", "))
		if promptUser("Install dependencies with pacman?") {
			fmt.Println("Installing dependencies...")
			if err := installArchPackages(missing); err != nil {
				fmt.Fprintf(os.Stderr, "Error: Failed to install packages: %v\n", err)
				os.Exit(1)
			}
			fmt.Println("Dependencies installed successfully!")
			return
		}
	}

	fmt.Fprintf(os.Stderr, "Error: Missing required dependencies: %s\n", strings.Join(missing, ", "))
	fmt.Fprintln(os.Stderr, "Please install them before running this program.")
	os.Exit(1)
}

func initSubmodules() {
	fmt.Println("Initializing git submodules...")
	cmds := [][]string{
		{"git", "submodule", "init"},
		{"git", "submodule", "update"},
	}
	for _, args := range cmds {
		cmd := exec.Command(args[0], args[1:]...)
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		if err := cmd.Run(); err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}
	}
}

func getAllApps(root string) []string {
	entries, _ := os.ReadDir(root)
	var apps []string
	for _, e := range entries {
		if e.IsDir() && e.Name() != ".git" && e.Name() != "." && e.Name() != "assets" {
			apps = append(apps, e.Name())
		}
	}
	sort.Strings(apps)
	return apps
}

func getAppTarget(app string) string {
	configFile := filepath.Join(app, "config.json")

	if data, err := os.ReadFile(configFile); err == nil {
		var cfg Config
		if json.Unmarshal(data, &cfg) == nil && cfg.Target != "" {
			target := os.ExpandEnv(cfg.Target)
			return target
		}
	}

	if app == "bash" || app == "git" {
		return homeDir
	}
	return configHome
}

func processApps() error {
	allApps := getAllApps(".")
	if len(selected) == 0 {
		selected = allApps
	}

	var failed []string

	for _, app := range selected {
		if _, err := os.Stat(app); os.IsNotExist(err) {
			fmt.Printf("Warning: %s directory not found, skipping\n", app)
			continue
		}
		target := getAppTarget(app)

		if dryRun {
			action := "stow"
			if uninstall {
				action = "unstow"
			}
			fmt.Printf("DRY RUN: Would %s %s into %s\n", action, app, target)
			continue
		}

		var err error
		if uninstall {
			err = unstow(target, app)
		} else {
			err = stow(target, app)
		}

		if err != nil {
			failed = append(failed, app)
		}
	}

	if len(failed) > 0 {
		fmt.Fprintf(os.Stderr, "\nWarning: Failed to process: %s\n", strings.Join(failed, ", "))
		return errors.New("some apps failed")
	}
	return nil
}

func stow(target, app string) error {
	if target == configHome {
		target = filepath.Join(target, app)
	}

	fmt.Printf("→ Stowing %s into %s\n", app, target)

	if err := os.MkdirAll(target, 0o755); err != nil {
		return fmt.Errorf("failed to create target dir %s: %w", target, err)
	}

	args := []string{"stow"}
	if verbose {
		args = append(args, "-v")
	}
	args = append(args, "-R", "-t", target, app)

	return runCmd(args)
}

func unstow(target, app string) error {
	if target == configHome {
		target = filepath.Join(target, app)
	}

	fmt.Printf("→ Unstowing %s from %s\n", app, target)

	args := []string{"stow"}
	if verbose {
		args = append(args, "-v")
	}
	args = append(args, "-D", "-t", target, app)

	return runCmd(args)
}

func runCmd(args []string) error {
	cmd := exec.Command(args[0], args[1:]...)
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	if verbose {
		cmd.Stdout = os.Stdout
	}
	err := cmd.Run()
	if err != nil {
		io.Copy(os.Stderr, &stderr)
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
	}
	return err
}
