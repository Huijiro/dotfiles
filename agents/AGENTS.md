# Agent Guidelines

## File Operations Tools

### Search & Discovery
When finding and grepping files, prefer using:
- **`rg` (ripgrep)**: For fast, pattern-based file searching and grepping
- **`fd`**: For efficient file discovery and filtering

These tools are faster and more user-friendly than their traditional counterparts (`grep` and `find`).

### Editing & Transformation
- **`sd`**: Modern find-and-replace tool, simpler and faster than sed for text substitution
- **`ast-grep`**: AST-based code searching and refactoring across multiple files with syntax awareness
- **`parallel`**: Run commands on multiple files concurrently for bulk operations

### Batch Processing
- **`parallel`**: Execute operations in parallel on multiple files to speed up bulk transformations
