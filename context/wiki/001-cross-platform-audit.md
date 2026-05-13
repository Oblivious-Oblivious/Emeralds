# Cross-platform audit (Emeralds)

**Date:** 2026-05-13

**Scope:** Crystal under `src/emeralds/`, `spec/`, root `Makefile`,
`install`, `.github/workflows/ci.yml`. Shards in `lib/` are not reviewed
line-by-line.

**Summary:** The CLI assumes a **Unix-like shell** for compilation and
cleanup, **clang/gcc-style** flags and artifacts (`.o`, `.a`, `-r` partial
link), optional **symlinks**, and **macOS debug bundles** (`.dSYM`). Windows
MSVC-style builds and `cmd.exe` semantics are not accommodated.

---

## 1. Shell execution and POSIX-only redirection

**Location:** `src/emeralds/modules/Terminal.cr` — `generic_cmd`

Runs the command string via **Crystal backticks** (default shell). When
`display` is false, appends **`2> /dev/null`**, which requires a POSIX-style
`/dev/null` and shell redirection.

**Impact:** Fails or misbehaves on Windows when the shell is `cmd.exe` or when
`/dev/null` is absent. Glob expansion in command strings still depends on the
shell when `display` is true.

**Potential fixes:**

- Prefer **`Process.run`** (or `Process.run(..., shell: true)` only when you
  truly need shell features) with explicit **`error:`** handling instead of
  string redirection: e.g. `error: Process::Redirect::Close` to discard stderr,
  or `error: IO::Memory.new` if you need to log failures when `display` is
  false.
- If you must keep a single string for the compiler invocation, on Windows you
  can still use **`shell: true`** with a **documented** shell (Git Bash path)
  — brittle, but some teams accept it; better is splitting into argv where
  feasible.
- For **`*.o`-style globs**, do not rely on the shell: use
  **`Dir.glob("*.o").join(' ')`** (or pass multiple `-o`/object args per your
  toolchain) and interpolate the explicit list into the command or argv array.

---

## 2. Hard-coded `rm -rf` (Unix-only)

**Location:** `src/emeralds/commands/Command.cr` — `install_deps`

Uses backticks: `` `rm -rf .git*` `` and `` `rm -rf .clang*` `` after cloning
and building dependencies.

**Impact:** `em install`, `em reinstall`, and nested dependency installs require
a Unix-style `rm` in PATH (or a shell that provides it, e.g. Git Bash).

**Potential fixes:**

- Replace with **stdlib-only** cleanup: e.g.
  `Dir.glob(File.join(".", ".git*")) { |p| FileUtils.rm_rf(p) }` and the same
  for `.clang*` (or iterate known names like `.git`, `.github` if you want to
  avoid broad globs).
- Optionally delete **`.git` as a directory** with `FileUtils.rm_rf(".git")` if
  the clone always uses a normal `.git` dir (your `git-repository` usage may
  leave only `.git`; confirm before dropping the glob).

---

## 3. Symbolic links (`FileUtils.ln_s`)

**Location:** `src/emeralds/commands/Command.cr` — `install_deps`

Creates `libs` inside each dependency with `FileUtils.ln_s` pointing at
`../../libs`.

**Impact:** On Windows, symlinks often need **Developer Mode** or
**administrator** rights. Failures are not handled with a junction/copy
fallback.

**Potential fixes:**

- **`begin` / `rescue`** around `FileUtils.ln_s`: on failure, fall back to
  **`FileUtils.cp_r`** of the `libs` tree (space cost, but works everywhere) or
  a documented **opt-in** env var (e.g. `EMERALDS_COPY_LIBS=1`) to skip
  symlinks entirely.
- On Windows only, consider **`cmd /c mklink /J`** for a directory junction
  (requires shell invocation) if you want a cheap link without full symlink
  privileges — more code, but avoids copying large trees.
- Long-term: **relative path in `em.json`** or “vendor mode” so that CI and
  Windows users never need a link into the parent `libs`.

---

## 4. Build and link model (compiler, flags, globs)

**Location:** `src/emeralds/commands/Command.cr` — `build_lib`,
`remove_objects_and_move_static_libs_to_export`, `build_app`

- Invokes **`cc`** from `em.json` with GCC/clang-style flags (`-c`, `-o`,
  `-r`, `-I`, `-std=c2x`, etc.).
- **`*.o`** in `generic_cmd` relies on **shell glob expansion**.
- Artifacts assumed: **`.o`**, **`.a`**, **`.a.test`**.

**Location:** `src/emeralds/commands/Init.cr` — default `em.json`

- Default **`cc`**: `clang`.
- Debug **`flags`** include **`-fsanitize=address`** (toolchain/OS sensitive).

**Impact:** MSVC (`cl` / `link`), `.obj`, `.lib`, and different link steps are
unsupported. `em.json` **`build`** override strings remain shell-specific.

**Potential fixes:**

- **Globs:** Build explicit file lists from `Dir.glob` for objects and pass them
  to the linker/archiver step (see §1).
- **Static libraries:** Replace **`cc -o foo.a -r *.o`** with a portable
  sequence where possible: **`llvm-ar`** / **`ar rcs foo.a *.o`** (still
  Unix-oriented but avoids shell glob if you glob in Crystal). MSVC path would
  use **`lib /out:foo.lib ...obj`** behind a `toolchain` or `cc_family` field in
  `em.json`.
- **Defaults in `Init`:** Ship **conservative** debug flags in generated
  `em.json` (e.g. `-g` only) and document ASan in README; or emit
  **OS-conditional** defaults using
  `{% if flag?(:win32) %} ... {% else %} ... {% end %}` in the generator.
- **Schema:** Add optional **`object_suffix`**, **`static_lib_flag`**, or
  **`archive_command`** overrides so downstream projects can describe Windows
  without forking Emeralds.

---

## 5. Running the built app (`./` and no `.exe`)

**Location:** `src/emeralds/modules/Terminal.cr` — `run`

Uses `Process.run` with `File.join(".", executable)` (no shell). Output binary
from `output_app` is `export/<name>` with **no `.exe`**.

**Impact:** On Windows, executables normally need a **`.exe`** suffix; execution
from cwd may also be restricted depending on policy.

**Potential fixes:**

- Resolve the path with a small helper, e.g. if `File.exists?(path)`, run it;
  else on Windows try **`path + ".exe"`** (and optionally **`.com`**).
- Alternatively always emit **`export/<name>.exe`** on Windows in `output_app`
  / linker **`-o`** so the name is stable across platforms.
- Prefer running with an **absolute path** built from `Dir.current` / `Path`
  to avoid “run from wrong cwd” issues on all OSes.

---

## 6. macOS-specific cleanup (`.dSYM`)

**Locations:**

- `src/emeralds/commands/Test.cr` — `Terminal.rm "spec/*.dSYM"`.
- `src/emeralds/commands/Clean.cr` — `*.dSYM`, `spec/*.dSYM`,
  `export/*.dSYM`.

**Impact:** Harmless no-ops on non-macOS if globs match nothing; patterns are
**Apple-specific** debug bundles.

**Potential fixes:**

- Wrap dSYM cleanup in **`{% if flag?(:darwin) %}`** … **`{% end %}`** so
  Windows/Linux never pay for useless globs (micro-optimization, clearer
  intent).
- Or centralize in **`Terminal.rm_dsym_globs`** that no-ops when `!darwin?`, so
  `Test`/`Clean` stay one-liners.

---

## 7. Path string assumptions

**Location:** `src/emeralds/modules/Terminal.cr` — `find`

Dedupes with `path.split('/').last`. If paths contain backslashes (Windows),
basename logic can be wrong.

**Location:** `src/emeralds/commands/Command.cr` — `delete_excluded_paths`

Uses `relative_path.to_s.lchop('/')`, assuming forward slashes in the relative
string.

**Impact:** Exclusion logic during dependency install may mis-compare paths on
Windows if separators differ.

**Potential fixes:**

- Use **`File.basename(path)`** or **`Path[path].basename`** for dedupe in
  `find`.
- In `delete_excluded_paths`, compare **`Path`** values: normalize with
  **`Path#normalize`** (or `relative_to` and then compare path segments)
  instead of `lchop('/')` on a string; match `exclude_patterns` using **`Path`**
  or forward-slash-normalized strings from a single helper.

---

## 8. `Init` assumes `em` on `PATH`

**Location:** `src/emeralds/commands/Init.cr` — `create_source_files`

Calls `Terminal.generic_cmd "em add get_value"`.

**Impact:** Requires **`em`** (or shell alias) on PATH and a working shell for
backticks; same class of issue on all OSes if `em` is not installed, but still
shell-bound.

**Potential fixes:**

- Invoke the **current executable**: e.g. `Process.executable_path` (Crystal
  exposes this when available) and run **`#{executable_path} add get_value`**
  via `Process.run` with argv `["add", "get_value"]` — no shell, no `em` name
  on PATH.
- Fallback chain: `Process.executable_path` → **`PROGRAM_NAME`** →
  **`"emeralds"`** on PATH, depending on what you want to guarantee.
- Best long-term: call **`Add`** logic **in-process** (refactor `Add` so `Init`
  can `require` and invoke a shared method) and avoid spawning a second process
  entirely.

---

## 9. Terminal output (Unicode + ANSI 256-color)

**Locations:** `src/emeralds/constants/cli.cr`,
`src/emeralds/extensions/String+colorize.cr`

Unicode cog/arrow and `\033[38;5;…m` 256-color sequences.

**Impact:** Legacy Windows consoles without VT can show mojibake or raw escape
codes; **Windows Terminal** is usually fine.

**Potential fixes:**

- Honor **`NO_COLOR`** (de facto standard) and optionally **`TERM=dumb`**:
  bypass color/emoji wrappers when set.
- Use **`STDOUT.tty?`** (and maybe `STDERR.tty?`) to disable styling when output
  is piped.
- Prefer **basic SGR** (`\e[31m` etc.) if 256-color is unnecessary on
  constrained terminals; or detect **Windows 10+ VT** before emitting 256-color
  codes (heavier; often `NO_COLOR` + tty is enough).

---

## 10. Repository tooling (developer / CI)

**Makefile:** `shards`, `cp`, `$(RM)` — Unix-oriented.

**install:** `#!/bin/sh`, `rm -rf`, `cp` to `/usr/local/bin/` — Unix-only.

**.github/workflows/ci.yml:** **Ubuntu** and **macOS** only; no **Windows**
matrix row.

**Potential fixes:**

- **`Makefile`:** Add a short **`BUILD.md`** note: on Windows run
  `shards build --release --no-debug` and copy `bin/emeralds` → `bin/em`
  manually, or add **`install.ps1`** / **`make.bat`** that mirrors the two
  targets without Unix `cp`/`$(RM)`.
- **`install`:** Split into **`install.sh`** (current) and **`install.ps1`**
  using `$env:ProgramFiles` or user-local bin; avoid hard-coded
  `/usr/local/bin` on Windows.
- **CI:** Add **`windows-latest`** with Crystal (if the `install-crystal` action
  supports it) and run **`shards install`** + **`crystal spec`** to catch path
  and compilation issues early — even if full C builds are skipped initially,
  the Crystal suite still validates.

---

## 11. Commented makefile generator (intent / future risk)

**Location:** `src/emeralds/commands/GenerateMakefile.cr`

Commented blocks reference `cp`, `mv`, `find`, `/dev/null`, `./spec/...` —
classic Unix makefile patterns. If re-enabled, they reinforce the same
portability constraints.

**Potential fixes:**

- If this feature returns, generate **per-OS stubs** or use **`make`** only on
  Unix; document Windows as “use Emeralds CLI / CMake” instead of generated
  Makefiles.
- Replace `find` with **`$(wildcard ...)`** / explicit file lists where make
  portability allows, or shell out to **Crystal-generated file lists**
  committed by `em makefile`.

---

## 12. Relatively portable areas

- `FileUtils`, `Dir.glob`, `File.join`, `HTTP::Client` for license fetch —
  generally cross-platform given a working Crystal runtime and TLS.
- `validate_filename` in `Command.cr` accounts for **Windows reserved device
  names** and forbidden characters — good for naming, independent of
  shell/build stack.

**Potential fixes:** None required; keep using **`Path`** for new path logic to
stay consistent with this strength.

---

## Fix playbook (priority sketch)

- **High — §1 `generic_cmd`:** `Process.run` + stderr `Close` or Memory;
  remove `/dev/null` string.
- **High — §2 `` `rm -rf` ``:** `FileUtils.rm_rf` + `Dir.glob` (or explicit
  paths).
- **High — §4 `*.o` in shell:** `Dir.glob` in Crystal, explicit list to
  compile/link.
- **Medium — §3 `ln_s`:** rescue → `cp_r` or env-gated copy mode.
- **Medium — §5 `run` / `.exe`:** Resolve `.exe` on Windows; consider
  absolute path.
- **Medium — §7 paths:** `File.basename` / `Path` comparisons in `find` and
  `delete_excluded_paths`.
- **Medium — §8 `Init`:** `Process.executable_path` argv spawn or in-process
  `Add`.
- **Low — §6 `.dSYM`:** Darwin-only guard or helper.
- **Low — §9 TTY / `NO_COLOR`:** Gate `colorize` / emoji constants.
- **Low — §10 repo scripts:** `install.ps1`, Windows CI row.

Treat **MSVC / `cl` support** (§4) as a **larger product decision**: it needs
explicit `em.json` schema and test matrix, not a one-line patch.
