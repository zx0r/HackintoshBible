#!/usr/bin/env fish

# Script: macOS Memory Optimizer (Fish Shell)
# Description: Automates memory optimization tasks, including clearing inactive memory, caches, and setting up a cron job.
# Author: zx0r
# Version: 1.0

# Function to clear inactive memory
function clear_inactive_memory
    echo "Clearing inactive memory..."
    sudo purge
    echo "Inactive memory cleared."
end

# Function to clear user and system caches
function clear_caches
    echo "Clearing user and system caches..."
    # Clear user caches
    rm -rf ~/Library/Caches/*
    # Clear system caches (requires sudo)
    sudo rm -rf /Library/Caches/*
    echo "Caches cleared."
end

# Function to monitor memory usage
function monitor_memory
    echo "Current memory usage:"
    top -l 1 -o mem | awk '/PhysMem/ {print $0}'
    echo "Memory pressure:"
    memory_pressure | grep "System-wide memory free percentage:"
end

# Function to set up a cron job for periodic memory optimization
function setup_cron_job
    echo "Setting up cron job for memory optimization..."
    # Add a cron job to run purge every hour
    echo "0 * * * * /usr/sbin/purge" | crontab -
    echo "Cron job set up to run every hour."
end

# Main script logic
function main
    echo "Starting macOS Memory Optimizer..."

    # Clear inactive memory
    clear_inactive_memory

    # Clear caches
    clear_caches

    # Monitor memory usage
    monitor_memory

    # Set up cron job
    setup_cron_job

    echo "Memory optimization tasks completed."
end

# Run the script
main