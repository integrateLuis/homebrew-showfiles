#!/usr/bin/env bash

######################################
# Determine the language for the code block
# based on the file extension
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
    *)    echo "" ;;
  esac
}

######################################
# Show usage/help
######################################
usage() {
  echo "Usage: $0 [options] [paths...]"
  echo ""
  echo "Options:"
  echo "  -d, --dirs <dir1> [dir2] [dir3] ...  One or more directory names to search (space separated)."
  echo "                                      Also accepts: --dirs=dir1,dir2"
  echo "  -f, --filename <pattern>            Pattern to filter files by name."
  echo ""
  echo "Examples:"
  echo "  $0 main.py"
  echo "  $0 src/ utils/"
  echo "  $0 --dirs models"
  echo "  $0 -d models api"
  echo "  $0 --dirs=models,api"
  echo "  $0 --filename=user"
  echo "  $0 -f user src/"
  echo "  $0 -d accounts business_model -f user"
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
    echo
    echo '```'
  else
    echo '```'
    cat "$file_path"
    echo
    echo '```'
  fi
  echo ""
}

######################################
# Process an individual file:
# - If a filename pattern was specified,
#   show it only if it matches.
# - If no pattern was specified, show it.
######################################
process_file() {
  local file_path="$1"

  # Check if it's a file (exists and is not a directory)
  if [ ! -f "$file_path" ]; then
    return
  fi

  # Si es .pyc, lo ignoramos
  [[ "$file_path" == *.pyc ]] && return

  if [ -n "$filename_pattern" ]; then
    # If we have a filename pattern, check if it matches
    if [[ "$file_path" == *"$filename_pattern"* ]]; then
      show_file_content "$file_path"
    fi
  else
    # No pattern => show it directly
    show_file_content "$file_path"
  fi
}

######################################
# Process a directory
#
# - If a filename pattern exists, only show
#   files whose name contains that pattern.
# - Otherwise, show all files.
######################################
process_directory() {
  local dir="$1"

  # Check if it's a directory
  if [ ! -d "$dir" ]; then
    echo "Does not exist or is not a directory: $dir"
    return
  fi

  while IFS= read -r -d '' file; do
    process_file "$file"
  done < <(find "$dir" -type f ! -name '*.pyc' -print0)
}

######################################
# ARG PARSING
######################################
dir_names=""
filename_pattern=""
ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    ### CAMBIOS: -d / --dirs
    -d|--dirs)
      shift
      # Podríamos toparnos con varias palabras que no empiecen con '-'
      # y queremos agregarlas a dir_names separados por coma.
      while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
        if [ -z "$dir_names" ]; then
          dir_names="$1"
        else
          dir_names="$dir_names,$1"
        fi
        shift
      done
      ;;
    # Alternativamente, si se usa --dirs=dir1,dir2...
    --dirs=*)
      # Aquí se considera el formato --dirs=dir1,dir2
      dir_names="${1#*=}"
      shift
      ;;
    -f|--filename)
      shift
      filename_pattern="$1"
      shift
      ;;
    --filename=*)
      filename_pattern="${1#*=}"
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
# 1) Process direct arguments:
#    - If they are directories, process_directory
#    - If they are files, process_file
if [ "${#ARGS[@]}" -gt 0 ]; then
  for path_arg in "${ARGS[@]}"; do
    if [ -d "$path_arg" ]; then
      process_directory "$path_arg"
    elif [ -f "$path_arg" ]; then
      process_file "$path_arg"
    else
      echo "Does not exist or is not a file/directory: $path_arg"
    fi
  done
fi

# 2) If directories were specified via -d/--dirs,
#    search for directories with those names and
#    process them
if [ -n "$dir_names" ]; then
  IFS=',' read -ra dirs_to_find <<< "$dir_names"
  for dir_to_find in "${dirs_to_find[@]}"; do
    while IFS= read -r found_dir; do
      process_directory "$found_dir"
    done < <(find . -type d -name "$dir_to_find" 2>/dev/null)
  done
fi

# 3) If no ARGS or --dirs were provided,
#    default to processing the current directory
if [ -z "$dir_names" ] && [ "${#ARGS[@]}" -eq 0 ]; then
  process_directory "."
fi
