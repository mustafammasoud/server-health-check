#!/usr/bin/env bash
#
# server_health_check.sh
#
# A DevOps capstone project script to check the health 
# of multiple remote servers via SSH.
#
# Usage: ./server_health_check.sh -f <server_list_file> -u <remote_user>
#
# --- Part 1: "Strict Mode"
# set -e : exit immediately if any command fails
# set -u : exit if an undefined variable is used
# set -o pipefail : if any command in a pipeline fails, treat the whole pipeline as failed
set -euo pipefail

# ---- Global Constants ----
# We use uppercase names by convention for constants
LOG_FILE=$(mktemp /tmp/server_health.XXXXXX)
readonly LOG_FILE
# 'readonly' means this value cannot be changed
# ---- Function Definitions ----
log_info() {
	echo "[INFO] $1 " | tee -a "$LOG_FILE"
}
# log an error message to stderr and to the log file
log_error() {
 # >&2 sends the output to stderr
	echo "[ERROR] $1" | tee -a "$LOG_FILE" >&2
}
# Print script usage
print_usage() {
	echo "Usage: $0 -f <server_list_file> -u <remote_user>"
	echo " -f: Path to a file containing a list of servers (one per line)."
	echo " -u: The remote SSH user to connect as."
	echo " -h: Display this help message."
}
# This function will clean up after the script
cleanup() {
	echo "Cleaning up temporary log file: $LOG_FILE"
	rm -f "$LOG_FILE"
}

# trap is the "hook". We tell it:
# "Whenever this script exits for any reason (EXIT),
# or receives INT/TERM signals, call the cleanup function."
trap cleanup EXIT INT TERM
echo "Script started. Log file created at: $LOG_FILE"

# This function performs the actual health check on a remote server
check_server() {
	local server="$1"
	local user="$2"

	log_info "..... Checking Server: $server ..... "

	# Use an SSH here-document to send a batch of commands in one connection
	ssh -n -o ConnectTimeout=5 "${user}@${server}" << 'EOF'
	# 1. Uptime Check
		echo "--- System Uptime ---"
		uptime
	# 2. Disk Check (Root Partition)
	echo "--- Disk Usage (Root /)"
	# NR==2 means print only the second line of df output
	df -h | awk 'NR==2 {print "Used: " $5 " (" $3 "/" $2 ")"}'
	# 3. Memory Check 
	echo "--- Memory usage ---"
	free -m | awk 'NR==2 {
	  printf "Used: %sMB / Total: %sMB (%.2f%%)\n",$3, $2, ($3/$2)*100
	}'
	# 4. Security Check (SSH brute-force failures)
	echo "--- Security (SSH) ---"
	AUTH_LOG="/var/log/auth.log"
	if [[ -f "$AUTH_LOG" ]]; then
		count=$(grep -c "Failed password" "$AUTH_LOG")
		echo "Fail SSH Attempts: $count"
	else
		echo "Failed SSH Attempts: auth log not found."
	fi
EOF
	log_info "--- Finished Check: $server ---"
}

