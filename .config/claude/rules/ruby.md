---
paths:
  - "**/*.rb"
---
# Ruby specific instructions

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
