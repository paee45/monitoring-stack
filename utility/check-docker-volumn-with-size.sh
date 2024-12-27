#!/bin/bash

# List all Docker volumes
volumes=$(docker volume ls -q)

# Loop through each volume
for volume in $volumes; do
  # Get the mount point of the volume
  mountpoint=$(docker volume inspect --format '{{ .Mountpoint }}' $volume)
  
  # Calculate the size of the volume
  size=$(sudo du -sh $mountpoint | awk '{print $1}')
  
  # Print the volume name and its size
  echo "Volume: $volume, Size: $size"
done