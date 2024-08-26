# dr_mod
Amiga mod loader and player for dragonruby

![main_screen](./readme_files/001_main_screen.png)

# Base documents

This MOD player is base on those 2 document

https://ftp.modland.com/pub/documents/format_documentation/Protracker%20effects%20(MODFIL12.TXT)%20(.mod).txt

https://www.lim.di.unimi.it/IEEE/VROS/FAQ/CRAMIG2.HTM

I curently can read patterns but I have issue with the sample frequency audio play.
If you have any hint please open an issue.

## Additional links

https://github.com/rombankzero/pocketmod/blob/master/pocketmod.h

https://github.com/electronoora/webaudio-mod-player/blob/master/js/pt.js

# Run the tests

Test are write with dr_spec

you can run them by typing

```
 dragonruby . --eval app/tests.rb --no-tick --spec-tags player,levels
```

## Adding spec

Lib spec are in
```
  lib/dr_mod_tracker/spec/*_spec.rb
```




# Pull request

Pull request are welcome.
Test must pass without regression.

Any design discussion or documentation are welcome too.
