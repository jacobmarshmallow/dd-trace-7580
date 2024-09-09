#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <with-dd|without-dd>"
    exit 1
fi

docker run -d --name repro_container repro:$1

LOG_LINE="Started CdsDatadogReproApplication in"
while true; do
    # Capture the new log output and extract the part after the colon
    LOG_OUTPUT=$(docker logs repro_container 2>&1 | grep "$LOG_LINE")
    if [ ! -z "$LOG_OUTPUT" ]; then
        # Extract everything after the colon
        LOG_MESSAGE=$(echo "$LOG_OUTPUT" | sed 's/.*: //')
        echo "$LOG_MESSAGE"
        break
    fi
    sleep 2
done

# Get the total number of classes loaded (denominator)
total_classes=$(docker exec repro_container bash -c "cat log/class-load.log | wc -l")
# Get the number of 'source: shared' occurrences (numerator)
shared_classes=$(docker exec repro_container bash -c "grep -o 'source: shared' -c log/class-load.log")
# Calculate the percentage (assuming bash supports floating point operations with bc)
if [ "$total_classes" -gt 0 ]; then
    percentage=$(echo "scale=2; ($shared_classes / $total_classes) * 100" | bc)
else
    percentage=0
fi

# Print the results
echo "Total classes loaded: $total_classes"
echo "Shared classes loaded: $shared_classes"
echo "Percentage of shared classes: $percentage%"

docker stop repro_container &> /dev/null
docker rm repro_container &> /dev/null