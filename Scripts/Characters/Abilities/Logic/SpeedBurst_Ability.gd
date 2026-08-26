## SpeedBurst_Ability.gd
## Short, powerful speed increase. This is Blaze's own main-slot ability —
## for speed-burst-flavored abilities used by OTHER characters/slots (Rex's
## combo, Blaze's own combo with Lyra), see BlazeLyraComboSpeed_Ability.gd
## and RexBlazeComboSpeed_Ability.gd instead of reusing this class.
##
## Reusing one static class for two different uses on the SAME player would
## collide: both would read/write the same "SpeedBurst_*" meta keys and the
## same cooldown key. Splitting into separate named ability scripts (each
## with its own ABILITY_NAME, so its own meta namespace and cooldown key)
## avoids that — and matches the one-script-per-named-ability convention.
class_name SpeedBurst_Ability
extends Object

const ABILITY_NAME := "SpeedBurst"

static func _can_use(player: Node2D) -> bool:
	if player.is_on_cooldown(ABILITY_NAME):
		return false
	var power_cost: float = player.get_meta("SpeedBurst_power_cost", 10.0)
	if power_cost > 0.0 and player.power < power_cost:
		return false
	return true

static func trigger(player: Node2D) -> Dictionary:
	if not _can_use(player):
		return {"success": false, "reason": "on_cooldown_or_no_power"}

	var power_cost: float        = player.get_meta("SpeedBurst_power_cost", 10.0)
	var cooldown_duration: float = player.get_meta("SpeedBurst_cooldown_duration", 8.0)
	var speed_bonus: float       = player.get_meta("SpeedBurst_speed_bonus", 5.0)
	var duration: float          = player.get_meta("SpeedBurst_duration", 4.0)

	player.spend_power(power_cost)
	player.set_cooldown(ABILITY_NAME, cooldown_duration)

	var bonus: float = speed_bonus + player.upgrade_level * 0.5
	var dur: float   = duration    + player.upgrade_level * 0.5
	player.apply_buff("speed_boost", dur, bonus)
	return {"success": true, "speed_bonus": bonus, "duration": dur}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	var speed_bonus: float = player.get_meta("SpeedBurst_speed_bonus", 5.0)
	var duration: float    = player.get_meta("SpeedBurst_duration", 4.0)
	return "+%.0f speed for %.0f seconds." % [speed_bonus, duration]
