# Code Style — dr_mod

## Parentheses

Style anti-parentheses : on omet les parentheses quand elles ne sont pas necessaires.

### Definitions de methodes

```ruby
# bon
def initialize mod_data, num
def set_name
def decode_pattern_line line_offset

# mauvais
def initialize(mod_data, num)
def set_name()
def decode_pattern_line(line_offset)
```

### Appels de methodes

Les parentheses restent necessaires quand l'ambiguite l'exige
(chainage, arguments imbriques, etc.).

## Line Length

Max 120 caracteres (standard moderne).

## Methodes extraites

Les methodes extraites pour la lisibilite doivent etre privees
sauf si elles font partie de l'API publique de la classe.

## Modules

On privilegie l'extraction en modules (ex: `CellBin`, `CellInfo`, `PatternPrint`)
pour garder les classes courtes et le code organise par responsabilite.

## Runtime

DragonRuby utilise mRuby. Certaines constructions valides en mRuby
(comme l'assignation de constantes dans une methode) sont
rejetees par CRuby/rubocop. La config rubocop est adaptee en consequence.

### Gotchas mRuby

- Les methodes "flottantes" (definies hors classe) peuvent fonctionner
  en mRuby mais c'est fragile. Toujours les rattacher a leur classe/module.
- `T_SPEC = CONSTANT` dans une methode est valide mRuby mais pas CRuby.
  Utiliser une variable locale (`t_spec = CONSTANT`) a la place.
