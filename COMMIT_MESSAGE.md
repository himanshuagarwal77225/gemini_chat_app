# Commit Message Guidelines

## Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code (formatting, etc)
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to the build process or auxiliary tools

## Scope

- **chat**: Chat feature related changes
- **ui**: UI components
- **api**: Gemini API integration
- **state**: State management (BLoC)
- **core**: Core functionality
- **deps**: Dependencies
- **config**: Configuration files

## Examples

### Feature Implementation

```
feat(chat): implement message sending functionality

- Add SendMessage use case
- Implement ChatRepository message handling
- Add error handling for API failures

Closes #123
```

### Bug Fix

```
fix(api): correct Gemini API model name

Change model name from 'gemini-pro' to 'gemini-1.0-pro'
to match latest API specifications.

Fixes #456
```

### Documentation Update

```
docs(readme): update setup instructions

- Add API key configuration steps
- Update prerequisites section
- Add troubleshooting guide
```

### Performance Improvement

```
perf(chat): optimize message list rendering

- Implement lazy loading for chat messages
- Add pagination support
- Cache previous messages

Performance improved by 40%
```

### Refactoring

```
refactor(state): improve chat state management

- Separate chat states into smaller components
- Remove redundant state checks
- Improve error handling flow
```

### Style Changes

```
style(ui): update chat bubble design

- Align with Material Design 3 guidelines
- Improve message timestamp positioning
- Update avatar styling
```

### Testing

```
test(chat): add unit tests for chat bloc

- Add tests for message sending
- Add tests for error handling
- Add mock API responses
```

## Best Practices

1. Keep the subject line under 50 characters
2. Use imperative mood in subject line
3. Don't end the subject line with a period
4. Separate subject from body with a blank line
5. Use the body to explain what and why vs. how
6. Reference issues and pull requests in the footer

## Commit Message Template

To set this template as your default Git commit message template:

```bash
git config --global commit.template .gitmessage

# Create .gitmessage file in your home directory with:
<type>(<scope>): <subject>

# Why is this change needed?
Prior to this change, 

# How does it address the issue?
This change

# What side effects does this change have?
Impact:

# Include links to tickets, issues or other resources
Closes #
``` 