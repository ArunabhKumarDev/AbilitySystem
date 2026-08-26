# Single ability: Speed_Burst

2 new files, 3 edited files (additive only). TEST_3 is the first entry in
the team array, so it spawns by default in Match.tscn.

New: Speed_Burst_Ability.gd, TEST_3_Abilities.gd
Edited: Character_Abilties.gd, Characters.gd, Player_Team_Management.gd

## Testing update

Since the last version, these were run against real Godot 4.7.1 (matching
your editor build exactly) using your actual `Player.tscn`, `Character.tscn`,
and `Characters.TEST_3()` — not a hand-built stand-in. All ability
assertions passed (speed/velocity/state/points checked directly against
real Player_Movement.gd physics).

Also attempted running the real `Match.tscn` end-to-end (real procedural
level generation). Confirmed it boots cleanly with no errors, but no
player ever spawns in my sandbox — `load_chunk()` defaults to empty
tile/object arrays, and I don't have the real `StreamingAssets` level-
layout data that would place a "Player Start" object. That's a data
limitation on my end, not a bug — the ability code itself is unchanged
from what's already in this package.
