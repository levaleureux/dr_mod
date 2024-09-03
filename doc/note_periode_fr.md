# Fonctionnement de `note_period` dans les fichiers MOD Amiga

Dans les fichiers MOD Amiga, la `note_period` est utilisée pour déterminer la fréquence de la note jouée. Cette fréquence est ensuite convertie en une note musicale, allant du Do au Si (C à B en notation anglaise) sur plusieurs octaves.

## Comment fonctionne la `note_period`

1. **Période (Period)** : La `note_period` est une valeur numérique qui détermine la fréquence d'une note en contrôlant la vitesse à laquelle un échantillon sonore est joué. Plus la valeur de la période est grande, plus la note sera basse (c'est-à-dire plus la fréquence sera basse). Inversement, une petite valeur de période correspond à une note plus haute.

2. **Conversion en note musicale** : La période est inversément proportionnelle à la fréquence de la note. Cette relation peut être décrite par la formule suivante :

   \[
   \text{Fréquence} = \frac{\text{Fréquence de base}}{\text{Période}}
   \]

   La "fréquence de base" dépend du matériel et des paramètres du fichier MOD. Pour l'Amiga, la fréquence de base est typiquement de 7093789.2 Hz (pour PAL) ou 7159090.5 Hz (pour NTSC).

3. **Tables de périodes** : Les fichiers MOD utilisent des tables de périodes pour correspondre les périodes aux notes musicales. Ces tables définissent les valeurs spécifiques de la période pour chaque note sur plusieurs octaves.

## Gamme de notes et octaves

- Les fichiers MOD classiques peuvent représenter plusieurs octaves. Les notes vont typiquement de `C-1` (Do de la première octave) à `B-3` (Si de la troisième octave), mais cela peut varier légèrement en fonction du module.

- **Période maximale** : 4095 est généralement associée à une des notes les plus basses possibles, probablement un `C-0` ou une note en dessous du Do dans la première octave, selon le nombre d'octaves supporté.

- **Période minimale** : La période minimale correspond à une des notes les plus hautes. Par exemple, une période de 113 pourrait correspondre à un `B-3` (Si de la troisième octave).

## Exemple de valeurs typiques dans une table de périodes (pour PAL)

- `C-1 (Do1)` : Période de 1712
- `D-1 (Ré1)` : Période de 1616
- `E-1 (Mi1)` : Période de 1524
- `F-1 (Fa1)` : Période de 1440
- `G-1 (Sol1)` : Période de 1356
- `A-1 (La1)` : Période de 1280
- `B-1 (Si1)` : Période de 1208
- `C-2 (Do2)` : Période de 856
- ...
- `B-3 (Si3)` : Période de 113

## Nombre d'octaves supportées

Typiquement, les modules MOD supportent 3 octaves (C-1 à B-3), mais cela peut varier légèrement selon la table de périodes utilisée.

## Conclusion

Le `note_period` dans un fichier MOD détermine la note musicale en se basant sur une table de correspondance. La valeur maximale (4095) correspond à une note très basse, alors que la valeur minimale (environ 113) correspond à une note très haute. Le module couvre généralement plusieurs octaves, avec chaque octave représentant un ensemble de valeurs de période spécifiques.
