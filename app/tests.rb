# Runner de tests dr_spec pour dr_mod.
# Usage: $DRAGONRUBY_BIN . --eval app/tests.rb --no-tick --exit-on-fail
#
# La couverture ne suit que la LOGIQUE PURE de dr_mod_tracker. Les modules
# d'affichage (*_print) et d'entrées/sorties (dr_binary_file, load_tool,
# samples_loader) sont chargés AVANT DrSpec::Coverage.start : définis mais
# non instrumentés -> seuil de couverture crédible sur le décodage du format.

require "lib/dr_spec/dragon_specs.rb"

# --- Modules non instrumentés (rendu / E-S), chargés en premier ----------
require "lib/dr_mod_tracker/sample/sample_print.rb"
require "lib/dr_mod_tracker/dr_binary_file.rb"
require "lib/dr_mod_tracker/load_tool.rb"
require "lib/dr_mod_tracker/samples_loader.rb"
require "lib/dr_mod_tracker/song/song_print.rb"
require "lib/dr_mod_tracker/pattern/pattern_print.rb"

# --- Logique pure : suivie par la couverture -----------------------------
DrSpec::Coverage.start "lib/dr_mod_tracker/"

require "lib/dr_mod_tracker/tracker_formats/protracker_1_1_b.rb"
require "lib/dr_mod_tracker/sample.rb"
require "lib/dr_mod_tracker/song/song_setup.rb"
require "lib/dr_mod_tracker/song.rb"
require "lib/dr_mod_tracker/cell/cell_bin.rb"
require "lib/dr_mod_tracker/cell/cell_info.rb"
require "lib/dr_mod_tracker/cell.rb"
require "lib/dr_mod_tracker/pattern.rb"

# --- Specs ---------------------------------------------------------------
require "spec/cell_spec.rb"
require "spec/sample_spec.rb"
require "spec/song_spec.rb"
require "spec/pattern_spec.rb"

run_specs
