---
name: console-usage
description: Modern command-line tools for efficient file operations, searching, and bulk transformations. Use this skill whenever working with files at scale - searching, finding, replacing, or refactoring code. Prefer rg (ripgrep) for searching, fd for file discovery, sd for find-and-replace, and ast-grep for syntax-aware refactoring. Use parallel for concurrent operations on multiple files. This skill helps you work faster and more safely with large codebases than traditional tools like grep, find, and sed.
---

# Console Usage: Modern CLI Tools

## Overview

This skill covers modern, faster alternatives to traditional command-line tools. These tools are designed for speed, usability, and safety when working with files at scale.

**When to use this skill:**
- Searching files and patterns (use `rg` instead of `grep`)
- Finding files efficiently (use `fd` instead of `find`)
- Replacing text in files (use `sd` instead of `sed`)
- Syntax-aware code refactoring (use `ast-grep` for multi-file changes)
- Bulk operations on multiple files (use `parallel` for concurrent execution)

---

## Tool Reference

### rg - Ripgrep (Fast Pattern Searching)

**Use instead of:** `grep`, `grep -r`

**Why:** 50-100x faster than grep, respects .gitignore by default, better output formatting, colored matches

**Basic usage:**
```bash
# Search for a pattern in current directory
rg "pattern"

# Search in specific file type
rg "pattern" --type rust

# Show context (lines before/after)
rg "pattern" -C 3

# Show only filenames
rg "pattern" -l

# Show line numbers
rg "pattern" -n

# Case-insensitive
rg -i "pattern"

# Regex patterns
rg "fn\s+\w+\(" --type rust
```

**Key advantages:**
- Respects .gitignore, .hgignore automatically
- Colored output by default
- Much faster on large codebases
- Supports regex out of the box
- Can filter by file type

**Example:**
```bash
# Find all functions in Rust files
rg "fn\s+(\w+)" --type rust -o

# Search TypeScript files for console.log
rg "console\.log" --type typescript
```

---

### fd - File Discovery

**Use instead of:** `find`

**Why:** Simpler syntax, respects .gitignore by default, colored output, faster on modern filesystems

**Basic usage:**
```bash
# Find files matching a pattern
fd "pattern"

# Find files by extension
fd -e rs          # Find all .rs files
fd -e "ts" -e "js"  # Find .ts or .js files

# Find directories only
fd -t d "name"

# Find files only
fd -t f "name"

# Exclude patterns
fd "pattern" --exclude node_modules

# Search from specific path
fd "pattern" /path/to/search
```

**Key advantages:**
- Respects .gitignore by default (use `--no-ignore` to override)
- Simpler syntax than `find`
- Colored output
- Faster on modern systems
- Intuitive type filtering

**Example:**
```bash
# Find all test files
fd "\.test\.(ts|js)$"

# Find files modified in last 7 days
fd -c newer "2024-03-01"

# Find Python files excluding __pycache__
fd -e py --exclude __pycache__
```

---

### sd - Safer Find-and-Replace

**Use instead of:** `sed`, `sed -i`

**Why:** Simpler syntax, preserves file permissions, atomic writes (no corruption), preview before replacing

**Basic usage:**
```bash
# Preview changes (doesn't modify files)
sd "old" "new" file.txt

# Replace in file (with backup)
sd -p "old" "new" file.txt  # Preview first

# Replace in multiple files
sd "old" "new" *.rs

# Use regex patterns
sd '(\w+)\s+(\w+)' '$2 $1' file.txt

# Replace preserving case
sd "old" "new" --case-preserve

# Replace with special characters
sd "const " "let " file.js
```

**Key advantages:**
- Safer than sed - atomic writes prevent corruption
- Simpler syntax - no need to escape delimiters
- Preview mode to check changes before applying
- Preserves file permissions
- Can use regex capture groups

**Comparison with sed:**
```bash
# sed (error-prone)
sed -i 's/old/new/g' file.txt

# sd (safer)
sd "old" "new" file.txt
```

---

### ast-grep - AST-Based Code Refactoring

**Use instead of:** regex-based find-and-replace for code

**Why:** Syntax-aware, matches actual code structure not just text patterns, handles nested structures, multi-file refactoring

**Basic usage:**
```bash
# Search for specific code patterns
sg "pattern" --lang rust

# Find function definitions
sg "fn \$FUNC\(\) {}" --lang rust

# Find and display matches
sg "const \$name = \$value" --lang typescript -p

# Replace across multiple files
sg --lang rust "old_fn\(\)" -r "new_fn()" --rewrite
```

**Key advantages:**
- Understands code syntax, not just text
- Handles nested structures correctly
- Can match code patterns precisely
- Multi-file refactoring with `--rewrite`
- Supports many languages: JavaScript, TypeScript, Python, Rust, Go, Java, C/C++, etc.

**Use cases:**
- Rename functions across a codebase
- Update API calls across projects
- Refactor imports
- Update deprecated patterns
- Replace method calls with new patterns

**Example:**
```bash
# Find all console.log calls and replace with logger.debug
sg "console\.log\(\$_\)" --lang typescript -r "logger.debug($_)" --rewrite

# Find all TODO comments
sg "//\s*TODO" --lang rust -p

# Refactor old import style to new
sg "import \$MODULE from '\$PATH'" --lang typescript -r "import type \$MODULE from '\$PATH'" --rewrite
```

---

### parallel - Concurrent Operations

**Use instead of:** Running commands in a loop

**Why:** Execute operations on multiple files concurrently, dramatically faster for I/O-bound tasks

**Basic usage:**
```bash
# Run command on each file
find . -name "*.js" | parallel node check {}

# Use with fd output
fd -e rs | parallel cargo check

# Run with 4 parallel jobs
parallel --jobs 4 "command {}" ::: file1 file2 file3

# Run different commands on different inputs
parallel "echo {}" ::: a b c
```

**Key advantages:**
- Runs multiple operations in parallel
- Dramatically faster for batch operations
- Works with pipes and find output
- Can specify number of parallel jobs
- Handles quoting and escaping automatically

**Example - Bulk transformation:**
```bash
# Format all Python files with black in parallel
fd -e py | parallel black {}

# Check all Rust files in parallel
fd -e rs | parallel cargo check {}

# Process multiple files concurrently
parallel "sed -i 's/old/new/g' {}" ::: *.txt
```

---

## Workflow Patterns

### Pattern 1: Find and Count

```bash
# Count occurrences of a pattern
rg "pattern" -c | wc -l

# Show files containing pattern with count
rg "pattern" -l | wc -l
```

### Pattern 2: Search then Replace

```bash
# 1. Preview what will change
rg "old_pattern" -n

# 2. Use sd to replace
sd "old_pattern" "new_pattern" file.txt

# 3. Or use ast-grep for code
sg "old_fn\(\)" --lang rust -p
sg "old_fn\(\)" --lang rust -r "new_fn()" --rewrite
```

### Pattern 3: Bulk File Operations

```bash
# 1. Find files matching criteria
fd -e rs --size +100k

# 2. Process in parallel
fd -e rs | parallel cargo check {}

# 3. Or transform in bulk
fd -e rs | parallel "sd 'old' 'new' {}"
```

### Pattern 4: Large Refactoring

```bash
# 1. Preview changes with ast-grep
sg "old_function\(\$_\)" --lang typescript -p

# 2. Apply rewrite across codebase
sg "old_function\(\$_\)" --lang typescript -r "new_function($_)" --rewrite

# 3. Verify changes
git diff
```

---

## Common Pitfalls to Avoid

### ❌ Don't use grep for large codebases
- Slow and inefficient
- ✅ Use `rg` instead

### ❌ Don't use find with complex filters
- Verbose and hard to read syntax
- ✅ Use `fd` instead

### ❌ Don't use sed for replacing in multiple files without backup
- Risk of corruption
- ✅ Use `sd` instead, or commit to git first

### ❌ Don't use regex to refactor code
- Fragile, breaks on nested structures, doesn't understand syntax
- ✅ Use `ast-grep` instead for code changes

### ❌ Don't process many files sequentially
- Slow for I/O-bound operations
- ✅ Use `parallel` for concurrent execution

---

## Installation & Availability

These tools are modern CLI utilities. Installation:

```bash
# macOS (Homebrew)
brew install ripgrep fd-find sd ast-grep parallel

# Linux (apt, various distros)
sudo apt install ripgrep fd-find sd ast-grep parallel

# Or from source
# ripgrep: https://github.com/BurntSushi/ripgrep
# fd: https://github.com/sharkdp/fd
# sd: https://github.com/chmln/sd
# ast-grep: https://github.com/ast-grep/ast-grep
# parallel: https://www.gnu.org/software/parallel/
```

---

## Quick Reference

| Task | Traditional | Modern |
|------|-----------|--------|
| Search files | `grep -r` | `rg` |
| Find files | `find . -name` | `fd` |
| Replace in file | `sed -i` | `sd` |
| Code refactoring | regex + sed | `ast-grep` |
| Bulk operations | for loop | `parallel` |

---

## Why These Tools Matter

1. **Performance**: 10-100x faster on real codebases
2. **Safety**: Atomic writes, backups, previews
3. **Usability**: Simpler syntax, sensible defaults
4. **Correctness**: AST-aware refactoring handles edge cases
5. **Concurrency**: Parallel execution for large workloads

Use these tools by default when working with files. They respect gitignore, provide better output, and work more safely than their traditional counterparts.
