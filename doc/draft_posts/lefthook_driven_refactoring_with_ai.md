# Lefthook-Driven Refactoring with an AI Agent: From 93 Offenses to Zero

## TL;DR

I set up lefthook with rubocop, reek, and dr_spec as pre-commit hooks
on my DragonRuby project. Then I paired with Claude Code to fix all
93 rubocop offenses. The hooks blocked every non-conforming commit,
forcing the AI to respect my coding standards — Sandi Metz rules
(5 lines per method, 100 lines per class), anti-parentheses style,
and proper module extraction.

## The Setup

I'm building **dr_mod**, an Amiga MOD file player in DragonRuby.
It parses ProTracker .mod files and plays them with a tracker UI.
The codebase had grown organically — long methods, duplicated code,
syntax errors that mRuby tolerated but CRuby wouldn't.

I wanted to stabilize the project before adding features. My approach:
**let the linter be the gatekeeper, not the AI.**

## The Hook Configuration

```yaml
# lefthook.yml
pre-commit:
  parallel: true
  commands:
    rubocop:
      run: bin/rubocop_quiet
    reek:
      run: bin/reek_quiet
    dr_spec:
      run: bin/dr_spec_quiet
```

Each wrapper reduces verbose output to a single line on success,
details only on failure. This saves tokens when working with an AI
agent — ~55K of raw output becomes ~500 chars.

### The dr_spec Challenge

DragonRuby tests run through the game engine binary, not standard Ruby.
The wrapper calls `dragonruby --eval app/tests.rb --no-tick --exit-on-fail`
and parses the output. The `DRAGONRUBY_BIN` env var makes it portable
for other contributors.

## The First Commit Attempt

After fixing the parentheses offenses (18 methods), I tried to commit:

```
🥊 rubocop (1.20 seconds)
exit status 1
```

Blocked. 93 offenses remained from before my changes. The hook doesn't
distinguish new from pre-existing offenses — it blocks on everything.

**Decision point:** I used `--no-verify` during stabilization, with a
clear rule: only while fixing pre-existing offenses. Once we hit zero,
no more bypass.

## How the AI Respects Architecture

This is where it gets interesting. When Claude extracted methods to
satisfy the 5-line rule, I insisted on proper module extraction
following existing patterns in the codebase:

```
cell.rb          → CellBin (binary parsing) + CellInfo (display)
sfx_player.rb    → SfxDraw (waveform rendering)
pattern_player.rb → PatternDraw + PatternSideBar + PatternAudio
```

Each module lives in a subdirectory matching the class name:
```
app/component/sfx_player/sfx_draw.rb
app/component/pattern_player/pattern_draw.rb
app/component/pattern_player/pattern_side_bar.rb
app/component/pattern_player/pattern_audio.rb
```

The AI proposed the extractions, but I validated every one. The
"propose and I validate" workflow is essential — the AI doesn't
make architectural decisions alone.

## What the Hooks Caught

### Real Bugs

The linter found actual bugs hiding in the code:

- **`sample.finetune = 0`** — assignment instead of comparison (`==`).
  The `attr_accessor :finetune` existed only to support this bug.
  Fix: `==` and remove the accessor.

- **`custom_rate`** — a dead `if/else` block overridden by a trailing
  expression. The entire conditional was never executed.

- **Floating methods** — methods defined outside their class that
  worked by accident in mRuby but would fail in CRuby.

### Design Issues

- **Dynamic constant assignment** — `T_SPEC = CONSTANT` inside methods.
  Valid mRuby, invalid CRuby. Fixed with local variables.

- **Dead code** — unused Procs, debug `puts`, commented-out experiments.
  The linter forced cleanup.

## The DragonRuby-Specific Challenges

DragonRuby uses mRuby, which is more permissive than CRuby. Rubocop
analyzes CRuby syntax. This creates false positives:

- `InstanceVariableAssumption` — DragonRuby's `attr_gtk` injects ivars
  at runtime. Disabled for `app/`.
- `Attribute` — public accessors are the standard DR pattern. Disabled.
- `TooManyMethods` — redundant with our strict ClassLength. Disabled.

Each decision is documented in `doc/reek_choices.md` with rationale.

## The Results

| Metric | Before | After |
|--------|--------|-------|
| Rubocop offenses | 93 | 0 |
| Reek warnings | 124 | 55 |
| Fatal errors | 4 | 0 |
| Bugs found | 3 | 0 |
| Modules extracted | 0 | 6 |
| Pre-commit hooks | 0 | 3 |

## What I Learned

1. **Hooks are better than rules.** Telling an AI "write clean code"
   is vague. A linter that blocks the commit is concrete.

2. **The 5-line rule forces good design.** Every method over 5 lines
   became a conversation about responsibility and extraction.

3. **Document your choices.** `doc/code_style.md` and `doc/reek_choices.md`
   explain WHY, not just WHAT. The AI reads these in future sessions.

4. **Visual verification is essential.** With only 4 tests, launching
   the game after every change caught regressions the tests missed.

5. **The AI proposes, the human disposes.** Every module extraction,
   every architectural decision went through explicit validation.
   The AI never acts alone on design.

## What's Next

- Fix the remaining 55 reek warnings
- Implement the virtual keyboard (#22, #32)
- Fix the sample frequency bug (#29) — already in progress
- Add more dr_spec tests (#28)
- Architecture diagrams with Mermaid (#24)

## About

dr_mod is open source: [github.com/levaleureux/dr_mod](https://github.com/levaleureux/dr_mod)

Built with DragonRuby Game Toolkit and tested with dr_spec,
a homemade RSpec-like framework for mRuby.

---

*Valeureux — March 2026*
