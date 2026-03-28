# Reek Configuration Choices — dr_mod

## Context

DragonRuby uses mRuby with specific patterns (attr_gtk, args-based API,
module mixins) that trigger false positives in reek. This document
explains each configuration choice.

## Disabled smells

### InstanceVariableAssumption — disabled for `app/`

DragonRuby's `attr_gtk` injects instance variables (`args`, `state`,
`outputs`, etc.) at runtime. Our extracted modules (PatternDraw, SfxDraw,
CellInfo...) also rely on parent class ivars by design. Reek cannot
see these cross-boundary assignments and flags them as assumptions.

### Attribute — disabled globally

DragonRuby components communicate via public attributes. `attr_gtk`
itself generates accessors. `attr_reader` and `attr_accessor` are
the standard way to expose state between components, scenes, and
the game loop. Flagging them as smells is counterproductive.

### TooManyMethods — disabled globally

We already enforce strict class length via rubocop (`Metrics/ClassLength`
max 100 lines, Sandi Metz rule). With 5-line methods and 100-line classes,
the method count is naturally bounded. This smell is redundant.

## Adjusted thresholds

### TooManyInstanceVariables — max 8

Game components manage state, config, and references simultaneously.
A player class typically needs: args, mod data, channels, counters,
flags, colors. The default max of 4 is too restrictive for this context.
8 is a reasonable ceiling that still catches bloated classes.

## Kept as-is (real smells to fix)

### DuplicateMethodCall

Legitimate in most cases. Some `args.inputs.keyboard` chains are
unavoidable in DragonRuby, but repeated calls elsewhere should be
refactored into local variables.

### UncommunicativeVariableName / UncommunicativeParameterName

Single-letter names for math/graphics coordinates (x, y, i) are
acceptable. Other cases should be renamed for clarity.

### UtilityFunction

Methods in modules that don't reference `self` may be legitimate
helper functions. Evaluate case by case — some should move to
a utility module, others are fine where they are.

### FeatureEnvy, NilCheck, UnusedParameters, LongParameterList

Real smells. Fix individually.
