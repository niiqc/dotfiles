if status is-login; and not set -q __guix_home_sourced
	set --prepend fish_function_path ~/.guix-home/profile/share/fish/functions
	fenv source ~/.profile
	set -e fish_function_path[1]
	set -g __guix_home_sourced 1
end
