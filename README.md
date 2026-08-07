# Server Health Check

A Bash automation script that connects to multiple remote Linux servers over SSH and performs basic health checks.

This project was built while learning Bash scripting and DevOps automation. It demonstrates how to automate common server administration tasks using shell scripting, SSH, and standard Linux utilities.

---

## Features

- Check system uptime
- Check root partition disk usage
- Check memory usage
- Count failed SSH login attempts
- Read multiple servers from a file
- Command-line argument parsing using `getopts`
- Error handling with Bash strict mode
- Logging to a temporary log file
- Automatic cleanup using `trap`

---

## Technologies

- Bash
- SSH
- Linux
- awk
- grep
- df
- free
- uptime

---

## Project Structure

```text
server-health-check/
├── server_health_check.sh
├── servers.txt
└── README.md
```

---

## Requirements

- Linux
- Bash
- SSH client
- SSH access to the target servers

---

## Usage

Make the script executable:

```bash
chmod +x server_health_check.sh
```

Run the script:

```bash
./server_health_check.sh -f servers.txt -u <remote_user>
```

Example:

```bash
./server_health_check.sh -f servers.txt -u ubuntu
```

---

## Example Server List

```text
# Production
192.168.1.10
192.168.1.11

# Development
192.168.1.20
```

---

## What the Script Checks

For each server, the script performs the following checks:

- System uptime
- Root filesystem disk usage
- Memory usage
- Failed SSH login attempts (from the authentication log)

---

## Future Improvements

Planned enhancements include:

- Parallel server execution
- CPU usage monitoring
- Running services status
- HTML reports
- JSON output
- Email notifications
- Slack or Discord notifications
- Colorized output
- Timestamped logs
- Configurable timeout values

---

## Learning Objectives

This project helped practice:

- Bash scripting
- Functions
- Arrays
- Loops
- Here Documents
- SSH automation
- Command-line arguments (`getopts`)
- Error handling
- Logging
- File processing

---

## License

This project is licensed under the MIT License.

