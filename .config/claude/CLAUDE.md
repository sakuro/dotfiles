# General tasks

- The purpose of a task is to achieve the original goal, not just to complete it. Do not arbitrarily change (simplify) the goal for the sake of completion.
- Backward compatibility considerations are only required from version 1.0 onwards.

# Communication

- A question is not a correction. If you only receive a question, provide an answer rather than making code changes.

# Ruby

- Access scopes such as `private` should be specified for each individual method or constant.
- Methods whose definition fits on a single line should be defined using the endless method syntax (without `end`).
- Methods that accept file paths as arguments should only accept `Pathname`. Do not implement flexibility to accept `String`.
- Do not use numbered parameters in blocks.

## Data class

- When defining a Data class, using a block is prohibited. Method definitions and documentation should be done by reopening the class.
- Prefer `[]` over `.new` for instantiation.

## RSpec

- Use of `described_class` is strictly prohibited.

## RuboCop

- Do not use disable comment directives to suppress violations. If needed, ask the user whether to add a file-level Exclude in .rubocop.yml instead.
- When Metrics cop violations occur, consider relaxing the limit and consult the user.
- Cop rule overrides in .rubocop.yml must be listed in alphabetical order by cop name.

# Other commands

## sed

- Check whether the sed being used is BSD sed or GNU sed.
- For GNU sed, use the `-i` option without specifying an extension.
- Use the `-e` option for edit commands to avoid ambiguity in command-line option parsing.

# Documentation

- Do not write everything you know. Be selective about content.
- Keep examples to a minimum.
- Avoid duplicating content that already exists in other documentation.
- After making significant additions or modifications, verify consistency with existing documentation.
- Avoid grandiose expressions, especially adverbial exaggerations.

## Comment

- Fundamental rule: Do not write what is obvious from reading the code.
- Criterion: If removing the comment still conveys the code's intent, it is unnecessary.

## Comments to write

- Why the implementation was done this way (Why / Why not)
- Non-obvious business rules
- External factors and constraints
- Warnings for code readers

## Comments not to write

- Literal translations of code
- Things obvious from function/variable names
- Section dividers
- Explanations of basic language or framework features

# File structure

Describes files that exist in most projects.

- README.md: プロジェクトの概要
- AGENTS.md: AIへの指示
- CLAUDE.md: AGENTS.mdへのシンボリックリンク。このファイルの修正は AGENTS.md の修正と同義である。このファイルの修正を行いたい場合は、代わりに AGENTS.md を修正する。
