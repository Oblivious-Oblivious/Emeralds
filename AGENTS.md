# AGENTS.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with
project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial
tasks, use judgment.

## 0. Non-negotiables

These override everything else:

1. **No flattery, no filler.** Start with the answer or action.
2. **Disagree when you disagree.** Never agree with false premises to be polite.
3. **Never fabricate.** If you don't know, read the file, run the command, or
   say so.
4. **Touch only what you must.** Every changed line must trace to the user's
   request.
5. **NO committing from an agent!! (human commits only).

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.
- If you write 20 lines and it be 5, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes,
simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it
work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer
rewrites due to overcomplication, and clarifying questions come before
implementation rather than after mistakes.

## 5. Project Context

### Stack

- Crystal project managed by Emeralds (`em` CLI) on top of Shards.
- `shard.yml` is the source of truth for targets and dependencies.
- `em.json` wraps it and delegates to `shards`/`crystal`.

### Commands

- `em help` - get information about all commands. use this to navigate.

- Examples:
  - `em build [app | lib] [debug | release]` — build the project.
  - `em test` — run tests.
  - `em install` — fetch dependencies into `lib/`.
  - `em add <name>` — scaffold a new module (source + spec).

### Layout

- `src/` — source files (`.cr`).
- `spec/` — spec files (`*.spec.cr`).
- `lib/` — installed shards (gitignored).
- `bin/` — compiled binaries (gitignored).
- `shard.yml` — targets and dependencies.
- `em.json` — Emeralds wrapper configuration.

### Code Style

- Run `em lint` to format and lint documents using ameba.
- Prefer the standard library over adding dependencies.
- Keep Crystal code style local: 2-space indent, final newline, LF,
  trimmed trailing whitespace.
- Max 80 chars/line. Follow existing script style.
- Crystal statements end with semicolons. Match surrounding files.
- Add focused tests for real behavior changes when practical.
- Single-statement lambdas: `->`; multi: `do...end`.

### Testing

- Framework: Crystal's built-in `spec`.
- Spec files live in `spec/` and end in `.spec.cr`.
- Run with `em test` (uses `crystal spec`).

### Running Tests

- `em test` wraps `crystal spec`.
- `crystal spec` runs everything under `spec/`.
- `crystal spec spec/foo_spec.cr` runs a single file.
- `crystal spec -e "pattern"` / `--tag focus` to filter examples.

### Conventions

- Keep Crystal code style local: 2-space indent, final newline, LF, trimmed
  trailing whitespace.
- Many Crystal statements end with semicolons. Match surrounding files.
- Commands inherit from `Emeralds::Command` and implement `message` and `block`.
- Add new command files to `src/emeralds.cr`, route them in `main.cr`, update
  `Help.cr`, and update `README.md` if user-facing.
- Prefer existing helpers in `Command.cr` and `Terminal.cr` over one-off shell
  or filesystem code.
- Use `File.join`, `Path`, `Dir.glob`, and `FileUtils` for paths.
- User-visible output uses `COG`, `ARROW`, `String#colorize`, and
  `String#mode`.
- `em.json` is the real config format. Treat `em.yml` references as stale docs
  unless the task is about compatibility.
- `Emfile.instance` memoizes parsed `em.json`; config models use
  `JSON::Serializable`.
- Current repository tests are minimal smoke coverage only. Add focused tests
  for real behavior changes when practical.
- Update both `shard.yml` and `src/emeralds/constants/version.cr` for version
  changes; update `CHANGELOG.md` for releases.

### Ruby Scripts

- **Always end statements with semicolons.** Non-negotiable.
- Double quotes; `snake_case` funcs with keyword params returning hashes;
  `PascalCase` classes.
- Single-statement lambdas: `->`; multi: `do...end`.
- Max 80 chars/line. Follow existing script style.
