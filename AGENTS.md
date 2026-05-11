# AGENTS.md

Read this file before every task.

**Working code only. Finish the job. Plausibility is not correctness.**

---

## 0. Non-negotiables

These override everything else:

1. **No flattery, no filler.** Start with the answer or action.
2. **Disagree when you disagree.** Never agree with false premises to be polite.
3. **Never fabricate.** If you don't know, read the file, run the command, or
   say so.
4. **Touch only what you must.** Every changed line must trace to the user's
   request.

---

## 1. Before writing code

- State your plan before editing. For non-trivial tasks, produce numbered steps
  with verification checks.
- Read files you'll touch and files that call them. Use subagents for
  exploration to keep main context clean.
- Match existing codebase patterns, even if you'd do it differently in a
  greenfield repo.
- Surface assumptions explicitly. Don't bury them in the implementation.

---

## 2. Writing code: minimum viable solution

- No features, abstractions, configurability, or error handling beyond what
  was asked.
- If 200 lines could be 50, rewrite before showing.
- Stop if you catch yourself adding "for future extensibility."
- Bias toward deleting code over adding it.

---

## 3. Surgical changes

- Don't "improve" adjacent code, comments, formatting, or imports not part of
  the task.
- Don't refactor working code just because you're in the file.
- Don't delete pre-existing dead code unless asked (mention it if you notice it).
- Clean up orphans from your own changes (unused imports, variables, functions).
- Match project style exactly: indentation, quotes, naming, file layout.

---

## 4. Verification

- Never report "done" from a plausible-looking diff alone.
- Debug root causes, not symptoms. Suppressing ≠ fixing.
- Use CLI tools (gh, aws, gcloud, kubectl) when they exist—they're more
  context-efficient.
- Read entire stack traces. Half-read traces produce wrong fixes.

---

## 5. Session hygiene

- Context is the constraint. Fresh sessions beat long ones with accumulated
  failures.
- After two failed corrections on the same issue, stop and ask user to reset
  with a sharper prompt.
- Use subagents for exploration tasks that'd pollute main context.
- Never commit anything by yourself.

---

## 6. Communication style

- Direct, not diplomatic. "This won't scale because X" beats "Interesting
  approach, but..."
- Concise by default. 2-3 short paragraphs unless user asks for depth.
- Clear answers when possible; when not, say so and give tradeoffs.
- No excessive bullets, unprompted headers, or emoji. Prose > structure for
  short answers.

---

## 7. Project context

### Stack

- Crystal CLI project. Emeralds is a package/build helper for downstream C
  applications and libraries.
- Package manager: Shards. Crystal requirement is `>= 1.0.0`.
- Shard target: `emeralds`, main file `src/emeralds.cr`; `make build` also
  copies the binary to `bin/em`.
- Dependency: `git-repository`; `connect-proxy` is transitive in `shard.lock`.
- Downstream projects use `em.json`, C compilers such as `clang`/`gcc`,
  `libs/`, `export/`, `src/`, and `spec/`.
- No Node, Python, Docker, Terraform, Kubernetes, or web app stack here.

### Commands

- Install deps: `shards install`.
- Build release: `make build` or `shards build --release --no-debug`.
- Build debug: `make debug` or `shards build`.
- Test: `make test` or `make spec`.
- CI test command: `crystal spec src/*.cr` (intentionally different from
  `make test`; mention this if relevant).
- Docs: `make document`.
- Clean build output: `make clean`.
- Lint: none configured.
- Format: no formatter command configured; follow `.editorconfig`.
- Typecheck: no separate command; Crystal build/spec is the check.
- Dev: build with `make debug`, then run `bin/emeralds` or `bin/em`.
- Avoid `./install` unless explicitly asked; it copies binaries to
  `/usr/local/bin`.

### Layout

- Entry point: `src/emeralds.cr`.
- CLI routing: `src/emeralds/main.cr`.
- Commands: `src/emeralds/commands/*.cr`.
- Command base/shared helpers: `src/emeralds/commands/Command.cr`.
- `em.json` model: `src/emeralds/emfile/`.
- Terminal/filesystem/git/http helpers: `src/emeralds/modules/Terminal.cr`.
- Constants: `src/emeralds/constants/`.
- Extensions: `src/emeralds/extensions/`.
- Tests: `spec/`.
- CI: `.github/workflows/ci.yml`.
- Docs: `README.md`, `CHANGELOG.md`, `CONTRIBUTING.md`.
- Don't modify generated/ignored output unless asked: `bin/`, `lib/`,
  `.shards/`, `docs/`, `*.dwarf`, `.DS_Store`, `fix_linux`.

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

### Syntax

- Crystal source uses `PascalCase` classes/modules such as
  `Emeralds::BuildAppDebug`.
- Command `block` methods usually return lambdas with `-> { ... }`.
- Generated content often uses `String.build`.
- JSON fields include `dev-dependencies` and `compile-flags`, mapped in Crystal
  to `dev_dependencies` and `compile_flags`.
- Downstream generated C defaults live in `Init.cr` and `Add.cr`; update README
  examples if generated output changes.

### Forbidden

- Committing from an agent (human commits only).
- Running `./install` without explicit user approval.
- Hand-editing `lib/`, `.shards/`, `bin/`, or generated `docs/`.
- Adding drive-by CI upgrades, format sweeps, or broad refactors.
- Expanding shell injection risk in `Terminal.generic_cmd`; be careful with
  `ARGV`, filenames, compiler flags, and values from `em.json`.
- Running downstream `em install`, `em reinstall`, or `em license` casually;
  they fetch from the network and mutate project files.
- Hiding known quirks: local tests and CI differ; `GenerateMakefile.cr` is mostly
  commented out; help mentions `em.yml` though code uses `em.json`; `Run` exists
  despite old changelog wording saying it was removed.
