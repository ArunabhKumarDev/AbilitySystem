# DDO Ability System

## Status

This is the `Abilities/` folder only — no stand-in player/character
scaffolding. Spawning and player setup are handled by the existing
project; this system expects a real `player: Node2D` to be handed to it
and calls a specific set of methods/properties on it (see
`PLAYER_API_CHECKLIST.md`).

**Not yet verified against the real codebase.** Every method/property name
below is an assumption, made without visibility into the actual player
script, `Characters.gd`, the team manager, or `Match.tscn`. Treat this as
a first pass to review against those files, not a finished integration.

## Structure

```
Scripts/Characters/Abilities/
  AbilityList.gd            ← Names enum (every ability) + rough categories

  Handlers/
    AbilityHandler.gd          shared base for the 6 character handlers
    Aria_Abilities.gd
    Blaze_Abilities.gd
    Nova_Abilities.gd
    Sage_Abilities.gd
    Rex_Abilities.gd
    Lyra_Abilities.gd

  Logic/                    ← one static script per named ability, 24 total
    BarrierShield_Ability.gd
    ...
```

## How it's meant to be triggered

```
player presses ability button
  → CharacterBase.trigger_ability(context)     [expected to exist on the
                                                  real player script]
  → {CharacterName}_Abilities.trigger_main_ability(context)
  → <AbilityName>_Ability.trigger(player)      [static call, player only]
```

Every ability script is `extends Object`, fully static — no `.new()`
anywhere. Per-character tunable values (power cost, cooldown, heal
amount, etc.) live as metadata on the player node itself
(`player.get_meta("<AbilityName>_<field>", default)`), set by each
character's Handler in `setup()`.

## What's confirmed vs. what's assumed

**Confirmed** (from direct feedback): no shared base class for ability
Logic scripts, `<Name>_Ability.gd` naming = enum entry name, `trigger()` +
`update_points()` required, static functions, config stored as player
metadata, `player: Node2D` as the only trigger() parameter.

**Assumed, needs checking against the real project:** every method name
in `PLAYER_API_CHECKLIST.md`, the meta-key naming convention, whether the
Handler layer should also drop its shared base class, and how
`update_points()` should hook into the real scoring/power systems.
