#!/bin/bash

# Configuration
SERVICE='nginx'

# Health Check Logic
if systemctl is-active --quiet $SERVICE; then
    echo "$(date): $SERVICE is running"
else
    echo "$(date): $SERVICE is DOWN — restarting"
    # Note: This command requires sudo/root permissions in a real environment
    systemctl restart $SERVICE
fi