#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

BURPP_VERSION="2025.11.5"

log_dir="/tmp"
function pkg_log() { echo "${log_dir}/pkg-$1.log"; }

system=(
		jq bash fish 7zip pciutils git libcurl4-openssl-dev
		sqlitebrowser kali-linux-firmware wget tmux neovim
)

network=(
		curl whois dnsutils nmap wireshark iproute2 net-tools
		aircrack-ng wget socat tcpdump ncat tcpreplay responder
		bettercap
)

post=(
		proxychains dns2tcp exe2hexbat
)

exploitation=(
		exploitdb metasploit-framework
		msfpc sqlmap jsql-injection
)

automation=(
		nuclei amass	wpscan recon-ng
)

info=(
		dnsrecon enum4linux wafw00f sslscan dnsenum dnstracer
		dnsmap smtp-user-enum netmask fping hping3 arping assetfinder
)

web=(
		caido ffuf subfinder sublist3r httprint webshells
		apache2 feroxbuster burpsuite
)

password=(
		hashcat hydra john john-data hashcat-utils smbmap
		seclists hash-identifier pdfcrack wordlists
)

langs=(
		php clang
)

windows=(
		netexec windows-binaries windows-privesc-check powercat
		dnschef regripper
)

rev=(
		apktool dex2jar jd-gui ghidra rz-ghidra jadx
		binwalk binwalk3 flashrom
)

labs=(
		juice-shop
)

wifi=(
		iw aircrack-ng macchanger
)


spinner_frames=('[/]' '[-]' '[\]' )

function install_pkg() {
	local group="$1" pkg="$2" idx="$3" total="$4"
	local percent=$(( idx * 100 / total ))
	local frame_idx=0

	printf "\r(%s) %s [%03d/%03d] (%02d%%) %s\033[K" \
				 "$group" "${spinner_frames[$frame_idx]}" "$idx" "$total" "$percent" "$pkg"

	if apt install -y "$pkg" >"$(pkg_log "$pkg")" 2>&1 & then
		local pid=$!
		while kill -0 "$pid" 2>/dev/null; do
			frame_idx=$(( (frame_idx + 1) % ${#spinner_frames[@]} ))
			printf "\r(%s) %s [%03d/%03d] (%02d%%) %s\033[K" \
						 "$group" "${spinner_frames[$frame_idx]}" "$idx" "$total" "$percent" "$pkg"
			sleep 0.2
		done
		if wait "$pid"; then
			printf "\r\033[K"
		else
			printf "\r\033[K\n"
			tail -n 15 "$(pkg_log "$pkg")"
			exit 1
		fi
	else
		printf "\r\033[K\n"
		tail -n 15 "$(pkg_log "$pkg")"
		exit 1
	fi
}


function install_burp_pro() {
	echo "installing burp suite."
	local url="https://portswigger.net/burp/releases/download?product=pro&version=${BURPP_VERSION}&type=Jar"
	wget -q "$url" -O /tmp/burp.jar
	mkdir -p /opt/burp
	mv /tmp/burp.jar /opt/burp
	echo "installation successful"
}

function main() {
	local groups=(
		system network post exploitation
		automation info web password
		langs windows rev labs wifi
	)

	local total=0
	for g in "${groups[@]}"; do
		local -n ref="$g"
		total=$(( total + ${#ref[@]} ))
	done

	apt update

	local idx=0
	for g in "${groups[@]}"; do
		local -n ref="$g"
		for pkg in "${ref[@]}"; do
			idx=$((idx + 1))
			install_pkg "$g" "$pkg" "$idx" "$total"
		done
	done

	echo "Install isolated packages outside apt"
	install_burp_pro
}

main "$@"
