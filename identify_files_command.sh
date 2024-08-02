#!/bin/bash

# Start timing
start_time=$(date +%s.%N)

# ASCII Art
cat << "EOF"
 __  __       _     _ _ __  __    _____ _                   _                   
|  \/  |     | |   (_) |  \/  |  / ____(_)                 | |                  
| \  / | ___ | |__  _| | \  / | | (___  _  __ _ _ __   __ _| |_ _   _ _ __ ___  
| |\/| |/ _ \| '_ \| | | |\/| |  \___ \| |/ _` | '_ \ / _` | __| | | | '__/ _ \ 
| |  | | (_) | |_) | | | |  | |  ____) | | (_| | | | | (_| | |_| |_| | | |  __/ 
|_|  |_|\___/|_.__/|_|_|_|  |_| |_____/|_|\__, |_| |_|\__,_|\__|\__,_|_|  \___| 
                                           __/ |                                
                                          |___/                                 
   _____                      _               
  / ____|                    | |              
 | (___   ___  __ _ _ __ ___| |__   ___ _ __ 
  \___ \ / _ \/ _` | '__/ __| '_ \ / _ \ '__|
  ____) |  __/ (_| | | | (__| | | |  __/ |   
 |_____/ \___|\__,_|_|  \___|_| |_|\___|_|   
EOF

# Function to display progress bar
progress_bar() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((width * current / total))
    local remaining=$((width - completed))
    printf "\r[%-${width}s] %d%%" "$(printf '%0.s#' $(seq 1 $completed))$(printf '%0.s-' $(seq 1 $remaining))" "$percentage"
}

# Get user input for folder path
read -p "Enter the folder path to scan: " folder_path

# Check if folder exists
if [ ! -d "$folder_path" ]; then
    echo "Error: Folder does not exist."
    exit 1
fi

# Get user input for archive name
read -p "Enter the archive name (leave empty for auto-generated name): " archive_name

# Generate archive name if not provided
if [ -z "$archive_name" ]; then
    folder_name=$(basename "$folder_path")
    timestamp=$(date +"%Y%m%d%H%M%S")
    guid=$(echo "$timestamp" | md5 | cut -c1-9)
    archive_name="${folder_name}_${guid}.tar"
fi

# Get script directory
script_dir=$(dirname "$0")

# Create temporary directory for identified files
temp_dir=$(mktemp -d)

# Find files without extension
files_without_extension=$(find "$folder_path" -type f ! -name "*.*")
total_files=$(echo "$files_without_extension" | wc -l)
current_file=0

echo "Scanning files..."

# Process each file
while IFS= read -r file; do
    ((current_file++))
    progress_bar $current_file $total_files
    
    # Use 'file' command to identify file type
    file_type=$(file -b --extension "$file")
    
    if [ "$file_type" != "???" ]; then
        extension=$(echo "$file_type" | cut -d'/' -f1)
        cp "$file" "$temp_dir/$(basename "$file").$extension"
    fi
done <<< "$files_without_extension"

echo -e "\nCreating archive..."

# Create tar archive
tar -cf "$script_dir/$archive_name" -C "$temp_dir" .

echo "Archive created: $script_dir/$archive_name"

# Clean up temporary directory
rm -rf "$temp_dir"

# End timing
end_time=$(date +%s.%N)

# Calculate execution time
execution_time=$(echo "$end_time - $start_time" | bc)

echo "Script execution time: $execution_time seconds"

# Create log file
log_file="${archive_name%.*}_log.txt"
{
    echo "Script execution time: $execution_time seconds"
    echo "Archive created: $script_dir/$archive_name"
    echo "Total files processed: $total_files"
    echo "Scan completed at: $(date)"
} > "$script_dir/$log_file"

echo "Log file created: $script_dir/$log_file"