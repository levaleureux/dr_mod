# Sample

Dans les fichiers MOD Amiga, bien que le sample_number soit techniquement codé sur 8 bits
(donc capable de représenter des valeurs de 0 à 255), en pratique,
le nombre de samples utilisés dans un module MOD est souvent bien inférieur à cela.

## Nombre de Samples dans les Fichiers MOD

Nombre de Samples Typique : Les formats MOD Amiga classiques (comme le format "ProTracker")
supportent généralement jusqu'à 31 samples.
Le premier sample est souvent numéroté comme 1 dans les logiciels de tracking,
mais le sample_number en interne pourrait être représenté par un index 0-basé,
ce qui signifie que vous avez des indices de 0 à 30 pour les 31 samples disponibles.

### Pourquoi 31?

Le format original MOD supportait 15 instruments, mais cela a été étendu à 31 dans les versions ultérieures.
Le nombre de 31 est une limitation de l'interface et de la structure des fichiers MOD Amiga.

## Interprétation des Bits

### Codage sur 8 Bits

Même si le sample_number est codé sur 8 bits, ce n'est qu'une limitation technique et structurelle.
En pratique, seuls les indices 0 à 30 (ou 1 à 31 si l'on parle en index 1-basé) sont utilisés pour référencer les samples.

## Pourquoi un Codage sur 8 Bits?
### Réserve de Bits

Le fait que 8 bits soient utilisés pour coder le sample_number donne une réserve de valeurs inutilisées
qui pourraient être utilisées pour des extensions ou des variations du format,
mais dans le cadre classique du format MOD, ces bits supplémentaires ne sont pas exploités.

## Conclusion

En résumé, même si le sample_number est codé sur 8 bits, en pratique,
les fichiers MOD Amiga n'utilisent qu'un nombre beaucoup plus restreint de samples, généralement jusqu'à 31.
Donc, dans la plupart des cas, les valeurs du sample_number que vous verrez seront entre 0 et 30.
