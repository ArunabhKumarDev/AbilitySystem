# All portable abilities: Speed_Burst, Forward_Dash, Double_Jump, Bonus_Perfect_Jump

8 new files, 3 edited files (additive only). TEST_3-6 are appended to the
team array alongside TEST_3, so all four spawn reachable via character
swap in Match.tscn.

## Why only 4, not all 24 originally built

The real Player script has no HP, shield, mana pool, or simultaneous-
teammates concept anywhere — only speed, dash, jump, velocity, the
modifier system, and a flat Points score. Everything below needs one of
those, nothing invented:

| Ability | Real mechanic used |
|---|---|
| Speed_Burst | `speed` + `add_modifier()` |
| Forward_Dash | `dash_speed`, `dash_time`, `velocity`, `current_state` (same pattern as Super_Jump's air dash) |
| Double_Jump | `jump_velocity`, `is_on_floor()` |
| Bonus_Perfect_Jump | `Player.update_points()` — the same scoring path Coin_Behavior.gd already uses |

## Excluded, and why

- Everything shield/heal/invincibility/team-support based — no HP, shield,
  or mana field exists on the real player; would require adding new
  fields to the shared Player_Movement.gd, which isn't my call to make.
- CoinCyclone / MissedCoinCollect / DoubleCoinValue — coins exist as real
  stage objects, but collection always adds exactly 1 point with no
  multiplier hook; pulling/multiplying them would mean editing world/stage
  files, not just ability files.
- SpeedAfterHazard — no hazard-detection/avoidance event exists to hook
  a passive off of.
- Hover, AirDash — excluded for being either redundant with Super_Jump's
  existing air-dash behavior, or resting on frame-ordering assumptions
  I'm less confident about than the four included here.

## What's still unverified (same caveat as the single-ability package)

Speed_Burst and Forward_Dash both depend on the same untested assumption:
that reapplying a modifier / setting current_state every frame behaves the
way I inferred from reading apply_modifiers() and handle_input(). If one
needs adjusting, the other likely does too — they share the pattern, not
just the risk.

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
