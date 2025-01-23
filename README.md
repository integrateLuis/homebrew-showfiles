# showfiles

**showfiles** is a simple shell script that displays the contents of files or directories, with optional syntax highlighting based on file extensions.

## Features

- Recursively processes directories.
- Displays contents of files in code blocks.
- Filters files by name with a pattern.
- Ignores `.pyc` files and (optionally) `.git` folders.

## Installation

### Using Homebrew (macOS or Linux)

1. Tap your custom Homebrew repository:

   ```bash
   brew tap integrateLuis/showfiles
   ```

2. Install the script:

   ```bash
   brew install showfiles
   ```

3. You can now run `showfiles` from any directory in your terminal.

### Manual Installation

If you prefer to install it manually without Homebrew:

1. Download `show_files.sh` from the repository.
2. Place it somewhere in your `$PATH`, for example:
   ```bash
   mv show_files.sh /usr/local/bin/showfiles
   chmod +x /usr/local/bin/showfiles
   ```
3. You can now use the command `showfiles` in your terminal.

## Usage

```
Usage: showfiles [options] [paths...]

Options:
  -d, --dirs <dir1> [dir2] [dir3] ...  One or more directory names to search (space separated).
                                      Also accepts: --dirs=dir1,dir2
  -f, --filename <pattern>            Pattern to filter files by name.

Examples:
  showfiles main.py
  showfiles src/ utils/
  showfiles --dirs models
  showfiles -d models api
  showfiles --dirs=models,api
  showfiles --filename=user
  showfiles -f user src/
  showfiles -d accounts business_model -f user
```

## Contributing

Feel free to open an [issue](https://github.com/integrateLuis/showfiles/issues) or submit a pull request if you find any bugs or have an idea for improvements.

## License

This project is licensed under the [MIT License](LICENSE).  
Yes, you can copy the MIT License text from a trusted source (for example, [opensource.org](https://opensource.org/licenses/MIT)) or from any other public reference. Just make sure to include it in a file named `LICENSE` at the root of your repository.