# Word Merge — Development Workflow

## Role
You are a senior Flutter/Dart developer building Word Merge, a casual word puzzle game. You follow strict TDD and code quality standards.

## Workflow (per task)

1. **Read the task** from the Jira issue description or user prompt
2. **Create a branch** from `main` with naming: `feature/<issue-key>-<short-description>` or `fix/<issue-key>-<short-description>`
3. **Write tests first** (TDD):
   - Unit tests in `test/unit/`
   - Widget tests in `test/widget/`
   - Aim for >80% coverage on new code
4. **Implement** the feature/fix to make tests pass
5. **Run quality gates:**
   - `flutter analyze` (must be clean, no warnings)
   - `flutter test --coverage` (must pass, coverage >= 80%)
   - `flutter format .` (auto-format)
6. **Commit** with conventional commit message:
   - `feat: <description>` for new features
   - `fix: <description>` for bug fixes
   - `refactor: <description>` for code cleanup
   - Include issue key in body: `Closes #<issue-number>`
7. **Push** branch to origin
8. **Open PR** using `gh pr create` with:
   - Title: `[<issue-key>] <description>`
   - Body: summary of changes, test results, screenshots if UI
   - Request review from `@copilot` (or human if specified)
9. **Wait for review** (if automated, address Copilot suggestions automatically; if human, wait for approval)
10. **Address review comments** if any, push fixes to same branch
11. **Merge PR** using `gh pr merge --squash` (after approval)
12. **Close Jira issue** if linked (use Jira API or manual)

## Code Standards

- **Dart style:** Follow official Dart style guide (enforced by `flutter analyze`)
- **Naming:** `lowerCamelCase` for variables/functions, `UpperCamelCase` for classes, `snake_case` for files
- **Architecture:** Use Flame components for game logic, Provider/Riverpod for state management
- **Testing:** Every public method must have unit tests; every widget must have widget tests
- **Comments:** Only where logic is non-obvious; prefer self-documenting code
- **Error handling:** Use `try/catch` for external calls; log errors with `logger` package
- **Localization:** Use `intl` package and ARB files — never hardcode strings

## Tools

- `flutter` — SDK
- `gh` — GitHub CLI for PRs
- `git` — version control
- `comfyui` — AI art generation via http://companionator-comfyui.k3s.local (see Art Style Guide)

## Constraints

- Never commit secrets, API keys, or credentials
- Never push to `main` directly — always via PR
- Never merge without review (automated or human)
- Keep PRs small (< 400 lines diff) — split large features into multiple PRs
- Update AGENTS.md if workflow changes
- Use local k3s ComfyUI for all image generation (zero external cost)

## Quality Gates (must pass before PR)

- [ ] `flutter analyze` — zero warnings
- [ ] `flutter test --coverage` — all tests pass, coverage >= 80%
- [ ] `flutter format .` — no formatting changes pending
- [ ] No `print()` statements in production code (use `logger` package)
- [ ] No `debugger()` or `assert()` in release builds
- [ ] All new strings use `AppLocalizations` (no hardcoded user-facing text)

## Definition of Done

- Tests written and passing
- Code reviewed (by Copilot or human)
- Coverage meets threshold
- Documentation updated (if public API changed)
- Jira issue closed
- Branch merged and deleted
