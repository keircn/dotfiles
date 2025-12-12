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

type Dependency struct {
	Binary  string
	Package string
	AUR     bool
}

type Config struct {
	Target string `json:"target"`
}

var requiredTools = []Dependency{
	{Binary: "stow", Package: "stow"},
	{Binary: "git", Package: "git"},
}

var appDependencies = map[string][]Dependency{
	"fish": {
		{Binary: "fish", Package: "fish"},
		{Binary: "eza", Package: "eza"},
		{Binary: "starship", Package: "starship"},
	},
	"vim":       {{Binary: "vim", Package: "vim"}},
	"bash":      {{Binary: "bash", Package: "bash"}},
	"fastfetch": {{Binary: "fastfetch", Package: "fastfetch"}},
	"alacritty": {{Binary: "alacritty", Package: "alacritty"}},
	"mako":      {{Binary: "mako", Package: "mako"}},
	"waybar": {
		{Binary: "waybar", Package: "waybar"},
		{Binary: "pavucontrol", Package: "pavucontrol"},
	},
	"starship": {{Binary: "starship", Package: "starship"}},
	"mpv":      {{Binary: "mpv", Package: "mpv"}},
	"fuzzel":   {{Binary: "fuzzel", Package: "fuzzel"}},
	"sway": {
		{Binary: "sway", Package: "sway"},
		{Binary: "swayidle", Package: "swayidle"},
		{Binary: "grim", Package: "grim"},
		{Binary: "slurp", Package: "slurp"},
		{Binary: "wl-copy", Package: "wl-clipboard"},
		{Binary: "clipman", Package: "clipman", AUR: true},
		{Binary: "brightnessctl", Package: "brightnessctl"},
		{Binary: "pactl", Package: "libpulse"},
		{Binary: "jq", Package: "jq"},
	},
	"hypr": {
		{Binary: "hyprlock", Package: "hyprlock"},
		{Binary: "hyprpicker", Package: "hyprpicker"},
	},
}

var (
	dryRun     bool
	uninstall  bool
	verbose    bool
	listOnly   bool
	showHelp   bool
	skipDeps   bool
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

	flag.BoolVar(&skipDeps, "skip-deps", false, "Skip dependency checking")
	flag.BoolVar(&skipDeps, "s", false, "Alias for --skip-deps")

	flag.BoolVar(&showHelp, "help", false, "Show this help message")
	flag.BoolVar(&showHelp, "h", false, "Alias for --help")
}

func usage() {
	fmt.Printf(`Usage: %s [OPTIONS] [APP...]

Options:
  -h, --help       Show this help message
  -n, --dry-run    Show what would be stowed without actually doing it
  -u, --uninstall  Unstow the specified apps
  -v, --verbose    Enable verbose output
  -l, --list       List all available apps
  -s, --skip-deps  Skip dependency checking

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

	var err error
	homeDir, err = os.UserHomeDir()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: Failed to get home directory: %v\n", err)
		os.Exit(1)
	}

	configHome = os.Getenv("XDG_CONFIG_HOME")
	if configHome == "" {
		configHome = filepath.Join(homeDir, ".config")
	}

	if showHelp {
		usage()
		os.Exit(0)
	}

	if listOnly {
		apps := getAllApps(".")
		fmt.Println("Available apps:")
		for _, app := range apps {
			fmt.Printf("  %s\n", app)
		}
		return
	}

	apps := selected
	if len(apps) == 0 {
		apps = getAllApps(".")
	}

	if !skipDeps {
		if err := checkRequiredTools(); err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}

		checkAppDependencies(apps)
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
	response, err := reader.ReadString('\n')
	if err != nil {
		return false
	}
	response = strings.TrimSpace(strings.ToLower(response))
	return response == "y" || response == "yes"
}

func installPackages(packages []string) error {
	if !isArchLinux() {
		return errors.New("automatic installation only supported on Arch Linux")
	}

	args := append([]string{"pacman", "-S", "--needed", "--noconfirm"}, packages...)
	cmd := exec.Command("sudo", args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	return cmd.Run()
}

func installAURPackage(pkg string) error {
	if err := installPackages([]string{"base-devel", "git"}); err != nil {
		return fmt.Errorf("failed to install build dependencies: %w", err)
	}

	tmpDir, err := os.MkdirTemp("", "aur-build-")
	if err != nil {
		return fmt.Errorf("failed to create temp directory: %w", err)
	}
	defer os.RemoveAll(tmpDir)

	pkgDir := filepath.Join(tmpDir, pkg)
	aurURL := fmt.Sprintf("https://aur.archlinux.org/%s.git", pkg)

	fmt.Printf("Cloning AUR package %s...\n", pkg)

	cloneCmd := exec.Command("git", "clone", "--depth=1", aurURL, pkgDir)
	cloneCmd.Stdout = os.Stdout
	cloneCmd.Stderr = os.Stderr
	if err := cloneCmd.Run(); err != nil {
		return fmt.Errorf("failed to clone %s: %w", aurURL, err)
	}

	fmt.Printf("Building %s...\n", pkg)

	makepkgCmd := exec.Command("makepkg", "-si", "--noconfirm")
	makepkgCmd.Dir = pkgDir
	makepkgCmd.Stdout = os.Stdout
	makepkgCmd.Stderr = os.Stderr
	makepkgCmd.Stdin = os.Stdin
	if err := makepkgCmd.Run(); err != nil {
		return fmt.Errorf("failed to build %s: %w", pkg, err)
	}

	return nil
}

func installAURPackages(packages []string) error {
	for _, pkg := range packages {
		if err := installAURPackage(pkg); err != nil {
			return err
		}
	}
	return nil
}

func checkMissing(deps []Dependency) (missing []Dependency) {
	for _, dep := range deps {
		if _, err := exec.LookPath(dep.Binary); err != nil {
			missing = append(missing, dep)
		}
	}
	return missing
}

func getPackageNames(deps []Dependency) (pacman []string, aur []string) {
	seenPacman := make(map[string]bool)
	seenAUR := make(map[string]bool)
	for _, dep := range deps {
		if dep.AUR {
			if !seenAUR[dep.Package] {
				seenAUR[dep.Package] = true
				aur = append(aur, dep.Package)
			}
		} else {
			if !seenPacman[dep.Package] {
				seenPacman[dep.Package] = true
				pacman = append(pacman, dep.Package)
			}
		}
	}
	sort.Strings(pacman)
	sort.Strings(aur)
	return pacman, aur
}

func formatMissing(deps []Dependency) string {
	var parts []string
	for _, dep := range deps {
		name := dep.Binary
		if dep.Binary != dep.Package {
			name = fmt.Sprintf("%s (package: %s)", dep.Binary, dep.Package)
		}
		if dep.AUR {
			name += " [AUR]"
		}
		parts = append(parts, name)
	}
	return strings.Join(parts, ", ")
}

func checkRequiredTools() error {
	missing := checkMissing(requiredTools)
	if len(missing) == 0 {
		return nil
	}

	pacmanPkgs, aurPkgs := getPackageNames(missing)

	if len(aurPkgs) > 0 {
		return fmt.Errorf("required tools from AUR not supported: %s", strings.Join(aurPkgs, ", "))
	}

	if isArchLinux() {
		fmt.Printf("Missing required tools: %s\n", formatMissing(missing))
		if promptUser("Install with pacman?") {
			if err := installPackages(pacmanPkgs); err != nil {
				return fmt.Errorf("failed to install packages: %w", err)
			}
			fmt.Println("Required tools installed successfully!")
			return nil
		}
	}

	return fmt.Errorf("missing required tools: %s\nPlease install them before running this program", formatMissing(missing))
}

func checkAppDependencies(apps []string) {
	var allMissing []Dependency
	seen := make(map[string]bool)

	for _, app := range apps {
		deps, ok := appDependencies[app]
		if !ok {
			dep := Dependency{Binary: app, Package: app}
			if _, err := exec.LookPath(app); err != nil {
				if !seen[app] {
					seen[app] = true
					allMissing = append(allMissing, dep)
				}
			}
			continue
		}

		for _, dep := range deps {
			if _, err := exec.LookPath(dep.Binary); err != nil {
				if !seen[dep.Binary] {
					seen[dep.Binary] = true
					allMissing = append(allMissing, dep)
				}
			}
		}
	}

	if len(allMissing) == 0 {
		return
	}

	pacmanPkgs, aurPkgs := getPackageNames(allMissing)

	if isArchLinux() {
		fmt.Printf("\nMissing app dependencies: %s\n", formatMissing(allMissing))

		if len(pacmanPkgs) > 0 {
			if promptUser(fmt.Sprintf("Install %d packages with pacman?", len(pacmanPkgs))) {
				if err := installPackages(pacmanPkgs); err != nil {
					fmt.Fprintf(os.Stderr, "Warning: Failed to install some packages: %v\n", err)
				} else {
					fmt.Println("Pacman packages installed successfully!")
				}
			}
		}

		if len(aurPkgs) > 0 {
			fmt.Printf("\nAUR packages needed: %s\n", strings.Join(aurPkgs, ", "))
			if promptUser(fmt.Sprintf("Install %d AUR packages? (requires base-devel)", len(aurPkgs))) {
				if err := installAURPackages(aurPkgs); err != nil {
					fmt.Fprintf(os.Stderr, "Warning: Failed to install some AUR packages: %v\n", err)
				} else {
					fmt.Println("AUR packages installed successfully!")
				}
			}
		}
		return
	}

	fmt.Fprintf(os.Stderr, "\nWarning: Missing app dependencies: %s\n", formatMissing(allMissing))
	fmt.Fprintln(os.Stderr, "Configurations will be stowed, but the apps may not work until installed.")
	fmt.Println()
}

func initSubmodules() {
	if verbose {
		fmt.Println("Initializing git submodules...")
	}
	cmd := exec.Command("git", "submodule", "update", "--init")
	if verbose {
		cmd.Stdout = os.Stdout
	}
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		fmt.Fprintf(os.Stderr, "Warning: Failed to initialize submodules: %v\n", err)
	}
}

func getAllApps(root string) []string {
	entries, err := os.ReadDir(root)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading directory: %v\n", err)
		return nil
	}

	var apps []string
	for _, e := range entries {
		name := e.Name()
		if !e.IsDir() || strings.HasPrefix(name, ".") || name == "assets" {
			continue
		}
		apps = append(apps, name)
	}
	sort.Strings(apps)
	return apps
}

func getAppTarget(app string) string {
	configFile := filepath.Join(app, "config.json")

	if data, err := os.ReadFile(configFile); err == nil {
		var cfg Config
		if json.Unmarshal(data, &cfg) == nil && cfg.Target != "" {
			return os.ExpandEnv(cfg.Target)
		}
	}

	if app == "bash" || app == "git" || app == "vim" {
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
		info, err := os.Stat(app)
		if os.IsNotExist(err) {
			fmt.Printf("Warning: %s directory not found, skipping\n", app)
			continue
		}
		if err != nil {
			fmt.Printf("Warning: Cannot access %s: %v, skipping\n", app, err)
			continue
		}
		if !info.IsDir() {
			fmt.Printf("Warning: %s is not a directory, skipping\n", app)
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
		fmt.Fprintf(os.Stderr, "Error: Failed to create target dir %s: %v\n", target, err)
		return err
	}

	args := []string{"-R", "-t", target, app}
	if verbose {
		args = append([]string{"-v"}, args...)
	}

	return runStow(args)
}

func unstow(target, app string) error {
	if target == configHome {
		target = filepath.Join(target, app)
	}

	fmt.Printf("→ Unstowing %s from %s\n", app, target)

	args := []string{"-D", "-t", target, app}
	if verbose {
		args = append([]string{"-v"}, args...)
	}

	return runStow(args)
}

func runStow(args []string) error {
	cmd := exec.Command("stow", args...)
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	if verbose {
		cmd.Stdout = os.Stdout
	}

	if err := cmd.Run(); err != nil {
		io.Copy(os.Stderr, &stderr)
		fmt.Fprintf(os.Stderr, "Error: stow failed: %v\n", err)
		return err
	}
	return nil
}
