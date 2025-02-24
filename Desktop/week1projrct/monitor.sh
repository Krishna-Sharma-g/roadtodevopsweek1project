#!/bin/bash

# Set threshold values
CPU_THRESHOLD=80  # Change this to your desired CPU usage limit
MEMORY_THRESHOLD=80  # Change this to your desired Memory usage limit

# Get system statistics
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

# Function to send alert
send_alert() {
    echo "ALERT! $1 usage is high: $2%" | mail -s "System Alert" gautamkrishnasharma1@gmail.com
}

# Check CPU Usage
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo "High CPU Usage: $CPU_USAGE%"
    send_alert "CPU" "$CPU_USAGE"
fi

# Check Memory Usage
if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
    echo "High Memory Usage: $MEMORY_USAGE%"
    send_alert "Memory" "$MEMORY_USAGE"
fi

# List Active Processes
echo "Top 5 Active Processes:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -6
