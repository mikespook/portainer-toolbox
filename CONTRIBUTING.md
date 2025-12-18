# Contributing to Portainer Toolbox

Thank you for your interest in contributing to Portainer Toolbox! This document provides guidelines for contributing to this project.

## How to Contribute

### Reporting Issues

If you find a bug or have a suggestion for improvement:

1. Check if the issue already exists in the [issue tracker](https://github.com/mikespook/portainer-toolbox/issues)
2. If not, create a new issue with:
   - A clear and descriptive title
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Your environment (OS, Docker version, etc.)

### Submitting Changes

1. Fork the repository
2. Create a new branch for your feature or bugfix:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Make your changes following the coding standards below
4. Test your changes thoroughly
5. Commit your changes with a descriptive commit message
6. Push to your fork and submit a pull request

## Coding Standards

### Shell Scripts

- Use `#!/bin/bash` shebang
- Include `set -e` for error handling
- Add comments explaining complex logic
- Use meaningful variable names in UPPER_CASE
- Include usage/help information for scripts with options
- Test scripts with shellcheck if available

### Script Structure

Each script should follow this structure:

```bash
#!/bin/bash

# Script Name and Description
# Brief explanation of what the script does

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values and configuration
# ...

# Main script logic
# ...
```

### Output Formatting

- Use colored output for better user experience:
  - Green for success messages
  - Yellow for warnings
  - Red for errors
- Provide clear progress indicators
- Include helpful error messages

### Documentation

- Update README.md if adding new scripts or features
- Add usage examples to the examples/ directory
- Include inline comments for complex operations
- Document all command-line options and parameters

## Testing

Before submitting a pull request:

1. Test your scripts in a clean environment
2. Verify scripts work with different input parameters
3. Check error handling and edge cases
4. Ensure scripts don't break existing functionality

## Pull Request Guidelines

- Keep pull requests focused on a single feature or bugfix
- Include a clear description of the changes
- Reference any related issues
- Ensure all scripts remain executable (chmod +x)
- Update documentation as needed

## Code of Conduct

- Be respectful and constructive in discussions
- Welcome newcomers and help them get started
- Focus on the code, not the person

## Questions?

If you have questions about contributing, feel free to open an issue for discussion.

Thank you for contributing!
