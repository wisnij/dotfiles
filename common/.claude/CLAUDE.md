# General

- When starting a subagent, explicitly announce it by name.
- Separate sentences in text with two spaces.
- When the user asks a question, just answer it.  If there is some related action to
  take, ask for confirmation before proceeding.  NEVER make changes or take any action
  in response to a question without explicit confirmation.

## Programming

- Do not invent requirements.
- Ask before adding a new project dependency.
- Do not introduce new dependencies without justification.
- Prefer correctness and clarity over cleverness.
- If uncertain about intent, ask a clarifying question.
- Respect existing project conventions.

### Python

- Do not use `assert` in production code, only in tests.  Production code should throw
  exceptions instead.
- Prefer making type annotations more specific over adding `cast`s or `type: ignore` comments.

## Markdown

- Always put at least one blank link between headings and any other text.
- Always put a blank line before the first element of top-level lists.
