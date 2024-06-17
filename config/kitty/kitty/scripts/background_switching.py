#!/usr/bin/env python3
import os
import subprocess

# Directory containing background images
bg_dir = os.path.expanduser("~/.config/kitty/backgrounds")
# File to store the current index
index_file = os.path.join(bg_dir, "bg_index")

# Get the list of background images
bg_files = sorted([f for f in os.listdir(bg_dir) if f.endswith(".jpg")])

# Get the current index
if os.path.exists(index_file):
    with open(index_file, "r") as f:
        index = int(f.read().strip())
else:
    index = 0

# Calculate the next index
new_index = (index + 1) % len(bg_files)

# Set the new background image
new_background = os.path.join(bg_dir, bg_files[new_index])
subprocess.run(["kitty", "@", "set-background-image", new_background])

# Update the index file
with open(index_file, "w") as f:
    f.write(str(new_index))
