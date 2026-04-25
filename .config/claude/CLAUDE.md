# General tasks

- The purpose of a task is to achieve the original goal, not just to complete it. Do not arbitrarily change (simplify) the goal for the sake of completion.
- Backward compatibility considerations are only required from version 1.0 onwards.
- Avoid implicit argument type coercion.

# Communication

- Always respond in Japanese when interacting with the user.
- Use English for all other outputs: GitHub issues, pull requests, commit messages, code comments, documentation, etc.
- A question is not a correction. If you only receive a question, provide an answer rather than making code changes.

# Shell commands

## sed

- Check whether the sed being used is BSD sed or GNU sed.
- For GNU sed, use the `-i` option without specifying an extension.
- Use the `-e` option for edit commands to avoid ambiguity in command-line option parsing.

## python

- Our python setup is minimum.  Avoid importing non-standard libraries such as PIL (Pillow).

# Documentation

- Do not write everything you know. Be selective about content.
- Keep examples to a minimum.
- Avoid duplicating content that already exists in other documentation.
- After making significant additions or modifications, verify consistency with existing documentation.
- Avoid grandiose expressions, especially adverbial exaggerations.

## Comment

- Fundamental rule: Do not write what is obvious from reading the code.
- Criterion: If removing the comment still conveys the code's intent, it is unnecessary.

### Comments to write

- Why the implementation was done this way (Why / Why not)
- Non-obvious business rules
- External factors and constraints
- Warnings for code readers

### Comments *NOT* to write

- Literal translations of code
- Things obvious from function/variable names
- Section dividers
- Explanations of basic language or framework features

# File structure

Describes files that exist in most projects.

- README.md: Project overview
- AGENTS.md: Instructions for AI
- CLAUDE.md: A symbolic link to AGENTS.md. Editing this file is equivalent to editing AGENTS.md. To make changes, edit AGENTS.md instead.
