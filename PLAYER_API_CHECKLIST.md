# Player API Checklist

The ability system (Handlers/ + Logic/) calls the methods and properties
below on whatever `player: Node2D` gets passed into it. None of this is
guesswork about game design — it's the exact, complete list of everything
currently referenced, pulled directly from the code.

Nothing in `Abilities/` defines a player/character script. It expects one
to already exist and expose this surface. Match names exactly, or rename
call sites in Logic/ + Handlers/ to whatever the real script uses.

## Methods

| Called as | Expected to do |
|---|---|
| `player.spend_power(amount) -> bool` | Deduct from a power/resource pool; return false if insufficient |
| `player.restore_power(amount) -> void` | Add back to the power pool, capped at max |
| `player.heal(amount) -> Dictionary` | Restore HP capped at max; return `{"healed": actual, "excess": overflow}` |
| `player.add_shield(amount) -> void` | Set/raise shield HP, mark shielded |
| `player.add_coins(amount) -> void` | Increase coin count |
| `player.add_score(amount) -> void` | Increase score — **placeholder**, only 2 abilities call this (DoubleCoinValue, BonusPerfectJump); real name/existence unconfirmed |
| `player.apply_buff(name: String, duration: float, value: float = 0.0) -> void` | Register a timed effect the game reads elsewhere (speed_boost, invincibility, hover, dashing, etc.) |
| `player.has_buff(name: String) -> bool` | Whether a named buff is currently active |
| `player.get_buff_value(name: String) -> float` | The stored value for an active buff |
| `player.is_on_cooldown(ability_name: String) -> bool` | Whether that ability's cooldown is still running |
| `player.set_cooldown(ability_name: String, duration: float) -> void` | Start/reset a cooldown |
| `player.jump() -> bool` | Attempt a jump; return false if no jumps remain |
| `player.emit_signal(name, ...)` | Standard Godot — only used for cosmetic/informational signals (`ability_triggered`) |
| `player.get(property_name) -> Variant` | Standard Godot `Object.get()` — used for optional situational data (see below); returns null safely if unset |
| `player.get_meta(key, default) / set_meta(key, value)` | Standard Godot metadata — this is how every ability's own tunable config is stored (see below) |

## Properties (read and/or written directly)

| Property | Type | Notes |
|---|---|---|
| `power` | float | current resource pool |
| `upgrade_level` | int | read by every ability to scale its effect |
| `shield_hp` | float | current shield HP remaining |
| `is_shielded` | bool | |
| `is_invincible` | bool | |
| `invincibility_blocks` | int | hit-counter, separate from `is_invincible` — see NextHitBlock_Ability.gd's header comment for why |
| `is_airborne` | bool | |
| `jump_count` / `max_jumps` | int | |
| `teammates` | Array | expected to hold other player-like objects with the same API |

## Situational properties — read via `player.get(...)`, may not exist yet

These are read defensively (falls back to a sane default if unset, never
crashes) because they weren't specified as part of the required player
API — they're assumptions about what the game loop might expose:

- `nearby_coins` (int) — CoinCyclone_Ability
- `missed_coins` (int) — MissedCoinCollect_Ability
- `hazard_avoided` (bool) — SpeedAfterHazard_Ability
- `coins_collected_this_frame` (int) — DoubleCoinValue_Ability's update_points()

If these don't exist on the real player, those specific abilities still
run — they just use their fallback default every time instead of reacting
to live game state.

## Per-ability tunable config — stored as player metadata

Every ability's own numbers (power_cost, cooldown_duration, shield_hp,
heal_amount, speed_bonus, etc.) are read via `player.get_meta("<AbilityName>_<field>", default)`.
Each character's Handler `setup()` sets these directly on `player` via
`set_meta(...)` before assigning the ability slots. No code changes
needed here — this already follows the meta-data pattern; just confirm
the key-naming convention (`"<AbilityName>_<field>"`) matches whatever's
expected, or it's a quick rename across the Handler `setup()` calls.
