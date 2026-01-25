#!/bin/bash

# Screenshot script that captures with grabit and uploads with hostman

# Run grabit to capture screenshot and get output
OUTPUT=$(grabit -o)

# Check if grabit succeeded
if [ $? -eq 0 ] && [ -n "$OUTPUT" ]; then
    # Upload the captured file using hostman
    hostman upload "$OUTPUT"
else
    echo "Error: grabit failed to capture screenshot"
    exit 1
fi