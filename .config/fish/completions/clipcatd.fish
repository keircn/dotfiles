# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_clipcatd_global_optspecs
	string join \n no-daemon r/replace c/config= history-file= grpc-host= grpc-port= grpc-socket-path= h/help V/version
end

function __fish_clipcatd_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_clipcatd_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_clipcatd_using_subcommand
	set -l cmd (__fish_clipcatd_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c clipcatd -n "__fish_clipcatd_needs_command" -s c -l config -d 'Specify a configuration file' -r -F
complete -c clipcatd -n "__fish_clipcatd_needs_command" -l history-file -d 'Specify a history file' -r -F
complete -c clipcatd -n "__fish_clipcatd_needs_command" -l grpc-host -d 'Specify gRPC host address' -r
complete -c clipcatd -n "__fish_clipcatd_needs_command" -l grpc-port -d 'Specify gRPC port number' -r
complete -c clipcatd -n "__fish_clipcatd_needs_command" -l grpc-socket-path -d 'Specify gRPC local socket path' -r -F
complete -c clipcatd -n "__fish_clipcatd_needs_command" -l no-daemon -d 'Do not run as daemon'
complete -c clipcatd -n "__fish_clipcatd_needs_command" -s r -l replace -d 'Try to replace existing daemon'
complete -c clipcatd -n "__fish_clipcatd_needs_command" -s h -l help -d 'Print help'
complete -c clipcatd -n "__fish_clipcatd_needs_command" -s V -l version -d 'Print version'
complete -c clipcatd -n "__fish_clipcatd_needs_command" -f -a "version" -d 'Print version information'
complete -c clipcatd -n "__fish_clipcatd_needs_command" -f -a "completions" -d 'Output shell completion code for the specified shell (bash, zsh, fish)'
complete -c clipcatd -n "__fish_clipcatd_needs_command" -f -a "default-config" -d 'Output default configuration'
complete -c clipcatd -n "__fish_clipcatd_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c clipcatd -n "__fish_clipcatd_using_subcommand version" -s h -l help -d 'Print help'
complete -c clipcatd -n "__fish_clipcatd_using_subcommand completions" -s h -l help -d 'Print help'
complete -c clipcatd -n "__fish_clipcatd_using_subcommand default-config" -s h -l help -d 'Print help'
complete -c clipcatd -n "__fish_clipcatd_using_subcommand help; and not __fish_seen_subcommand_from version completions default-config help" -f -a "version" -d 'Print version information'
complete -c clipcatd -n "__fish_clipcatd_using_subcommand help; and not __fish_seen_subcommand_from version completions default-config help" -f -a "completions" -d 'Output shell completion code for the specified shell (bash, zsh, fish)'
complete -c clipcatd -n "__fish_clipcatd_using_subcommand help; and not __fish_seen_subcommand_from version completions default-config help" -f -a "default-config" -d 'Output default configuration'
complete -c clipcatd -n "__fish_clipcatd_using_subcommand help; and not __fish_seen_subcommand_from version completions default-config help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
