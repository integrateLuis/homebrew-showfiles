#!/usr/bin/env bash

######################################
# Determine the language based on the file extension
# for use in the code block.
######################################
get_lang_by_extension() {
  local filename="$1"
  local extension="${filename##*.}"

  case "$extension" in
    py)   echo "python" ;;
    js)   echo "javascript" ;;
    ts)   echo "typescript" ;;
    sh)   echo "bash" ;;
    rb)   echo "ruby" ;;
    go)   echo "go" ;;
    java) echo "java" ;;
    cpp)  echo "cpp" ;;
    c)    echo "c" ;;
    md)   echo "markdown" ;;
    *)    echo "" ;;  # Not specified
  esac
}


######################################
# Show usage/help
######################################
usage() {
  echo "Usage: $0 [options] [paths...]"
  echo ""
  echo "Options:"
  echo "  -d, --dirs   Comma-separated list of directory names to search."
  echo ""
  echo "Examples:"
  echo "  $0 main.py"
  echo "  $0 src/ utils/"
  echo "  $0 --dirs=models"
  echo "  $0 -d=models,api"
  echo "  $0 --dirs models,api"
  echo ""
  exit 1
}

######################################
# Display the contents of a file
######################################
show_file_content() {
  local file_path="$1"
  local lang
  lang=$(get_lang_by_extension "$file_path")

  echo "========================================="
  echo "File: $file_path"
  echo "========================================="
  if [ -n "$lang" ]; then
    echo '```'"$lang"
    cat "$file_path"
    echo # Empty line for correct formatting on markdown render
    echo '```'
  else
    # If no specific language is determined, still show a generic code block
    echo '```'
    cat "$file_path"
    echo # Empty line for correct formatting on markdown render
    echo '```'
  fi
  echo ""
}

######################################
# Process a directory, showing the
# content of each file (recursively).
######################################
process_directory() {
  local dir="$1"
  # Here you could filter by extensions or show all files
  # In this example, all files are listed.
  # Adjust as needed (e.g., find "$dir" -type f -name "*.py")
  while IFS= read -r -d '' file; do
    show_file_content "$file"
  done < <(find "$dir" -type f -print0)
}

######################################
# ARGUMENT PARSING
######################################
# List of directories to search. Can be multiple ("models,api,...")
dir_names=""

ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--dirs)
      # For cases like: showfiles --dirs models,api
      # or showfiles -d models,api
      shift
      dir_names="$1"
      shift
      ;;
    --dirs=*)
      # For cases like: showfiles --dirs=models,api
      # Extract everything after '='
      dir_names="${1#*=}"
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      ARGS+=("$1")
      shift
      ;;
  esac
done


######################################
# MAIN LOGIC
######################################
# 1) If direct paths were specified in ARGS, process them first
if [ "${#ARGS[@]}" -gt 0 ]; then
  for path_arg in "${ARGS[@]}"; do
    if [ -f "$path_arg" ]; then
      # It's a file
      show_file_content "$path_arg"
    elif [ -d "$path_arg" ]; then
      # It's a directory
      process_directory "$path_arg"
    else
      echo "Does not exist or is not a file/directory: $path_arg"
    fi
  done
fi

# 2) If directory names were specified (-d, --dirs)
if [ -n "$dir_names" ]; then
  # Convert the comma-separated list into an array
  IFS=',' read -ra dirs_to_find <<< "$dir_names"

  for dir_to_find in "${dirs_to_find[@]}"; do
    # Use find to locate directories matching the name
    while IFS= read -r -d '' found_dir; do
      # Process each found directory
      process_directory "$found_dir"
    done < <(find . -type d -name "$dir_to_find" -print0)
  done
fi