#!/usr/bin/env bash

# Function to determine the language based on the file extension
# so we can include it in the fenced code block (```lang).
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
    *)    echo "" ;;  # No specific language found
  esac
}

# Function to process a file:
# - Print the file name.
# - Check if it's empty. If empty, print "Empty file".
# - If not empty, print the contents in triple backticks, optionally specifying language.
process_file() {
  local file="$1"
  echo "=== $file ==="

  if [[ ! -s "$file" ]]; then
    echo "Empty file"
  else
    local lang
    lang="$(get_lang_by_extension "$file")"
    echo "\`\`\`$lang"
    cat "$file"
    echo "\`\`\`"
  fi

  echo  # Blank line
}

# Function to process a directory:
# - Recursively find all files within it.
# - Call process_file for each file.
process_directory() {
  local dir="$1"
  echo "=== Directory: $dir ==="

  find "$dir" -type f | while read -r file; do
    process_file "$file"
  done
}

# Main loop: iterate through all arguments.
for path in "$@"; do
  if [[ -f "$path" ]]; then
    # If it's a file
    process_file "$path"
  elif [[ -d "$path" ]]; then
    # If it's a directory
    process_directory "$path"
  else
    # Not a file, not a directory, or doesn't exist
    echo "Doesn't exist or is not a regular file/directory: $path"
  fi
done
