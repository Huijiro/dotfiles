# Agent Guidelines

## Git Operations

### Remote Pushing
- **Always ask before pushing** to remote repositories. Never automatically push commits or branches.
- Confirm with the user before performing `git push`, `git push --force`, or similar remote operations.
- This applies to PR updates, branch pushes, and any other remote git operations.

## File Operations Tools

### Search & Discovery
When finding and grepping files, prefer using:
- **`rg` (ripgrep)**: For fast, pattern-based file searching and grepping
- **`fd`**: For efficient file discovery and filtering

These tools are faster and more user-friendly than their traditional counterparts (`grep` and `find`).

### Viewing Files
- **`bat`**: Use `bat` instead of `cat` for viewing file contents, with syntax highlighting and line numbers

### Understanding Commands
- **`tldr`**: Use `tldr` instead of `man` to quickly understand how commands work with practical examples

### Editing & Transformation
- **`sd`**: Modern find-and-replace tool, simpler and faster than sed for text substitution
- **`ast-grep`**: AST-based code searching and refactoring across multiple files with syntax awareness
- **`parallel`**: Run commands on multiple files concurrently for bulk operations

### Batch Processing
- **`parallel`**: Execute operations in parallel on multiple files to speed up bulk transformations
