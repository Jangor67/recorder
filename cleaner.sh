#!/usr/bin/bash

basepath=${1:-'/mnt/usb1'}
threshold=${2:-90}

if [ ! -d "$basepath" ]; then
  echo "unable to find basepath: $basepath"
  exit 1
fi

# Function to remove the oldest directory
remove_oldest_directory() {
    DIR_CNT2=$(ls -1 "$basepath/cam2" | wc -l)
    DIR_CNT3=$(ls -1 "$basepath/cam3" | wc -l)
    if [[ "$DIR_CNT2" -ge "$DIR_CNT3" ]]; then
      OLDEST_DIR=$(ls -1 "$basepath/cam2" | sort | head -n 1)
      COMPLETE_PATH="$basepath/cam2/$OLDEST_DIR"
      # go one level deeper
      OLDEST_DIR=$(ls -1 "$COMPLETE_PATH" | sort | head -n 1)
      if [ -n "$OLDEST_DIR" ]; then
        COMPLETE_PATH="$COMPLETE_PATH/$OLDEST_DIR"
      fi
    else
      OLDEST_DIR=$(ls -1 "$basepath/cam3" | sort | head -n 1)
      COMPLETE_PATH="$basepath/cam3/$OLDEST_DIR"
      # go one level deeper
      OLDEST_DIR=$(ls -1 "$COMPLETE_PATH" | sort | head -n 1)
      if [ -n "$OLDEST_DIR" ]; then
        COMPLETE_PATH="$COMPLETE_PATH/$OLDEST_DIR"
      fi
    fi
    
    if [ -n "$OLDEST_DIR" ]; then
        echo "Removing oldest directory: $COMPLETTE_PATH"
        echo sudo rm -rf "$COMPLETE_PATH"
        exit 1
    else
        echo "No directories found to delete."
    fi
}

# Check disk usage percentage
USAGE=$(df -h "$basepath" | awk 'NR==2 {print $5}' | sed 's/%//')

# Keep removing the oldest directory until usage is below the threshold
while [[ "$USAGE" -ge "$threshold" ]]; do
    echo "Disk usage is $USAGE%, exceeding $threshold% threshold."
    remove_oldest_directory
    
    # Re-check disk usage after deletion
    USAGE=$(df -h "$basepath" | awk 'NR==2 {print $5}' | sed 's/%//')
done

echo "Cleanup complete. Current usage: $USAGE%"
