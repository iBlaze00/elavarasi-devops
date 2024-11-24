#!/bin/bash

# Path to the HTML file
HTML_FILE="index.html"

# Port to serve the file
PORT=8000

# Check if the HTML file exists
if [ ! -f "$HTML_FILE" ]; then
  echo "Error: $HTML_FILE not found."
  exit 1
fi

# Start a temporary HTTP server
echo "Starting HTTP server to serve $HTML_FILE..."
python3 -m http.server $PORT > /dev/null 2>&1 &
SERVER_PID=$!

# Give the server some time to start
sleep 2

# Test if the HTML file loads successfully
echo "Testing if $HTML_FILE is accessible..."
curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT/$HTML_FILE | grep -q "200"

if [ $? -eq 0 ]; then
  echo "Test passed: $HTML_FILE loaded successfully."
  # Stop the server
  kill $SERVER_PID
  exit 0
else
  echo "Test failed: Unable to load $HTML_FILE."
  # Stop the server
  kill $SERVER_PID
  exit 1
fi
