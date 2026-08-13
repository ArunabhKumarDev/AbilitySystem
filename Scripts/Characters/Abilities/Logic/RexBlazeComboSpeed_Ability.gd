## RexBlazeComboSpeed_Ability.gd
## Rex's combination ability (paired with Blaze) — a free speed boost
## piggybacked onto his invincibility. Kept separate from SpeedBurst_Ability
## for the same meta-namespace/cooldown-key reason as BlazeLyraComboSpeed.
class_name RexBlazeComboSpeed_Ability
extends Object

const ABILITY_NAME := "RexBlazeComboSpeed"

static func trigger(player: Node2D) -> Dictionary:
	var speed_bonus: float = player.get_meta("RexBlazeComboSpeed_speed_bonus", 6.0)
	var duration: float    = player.get_meta("RexBlazeComboSpeed_duration", 3.5)
	player.apply_buff("speed_boost", duration, speed_bonus)
	return {"success": true, "speed_bonus": speed_bonus, "duration": duration}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	return "Free speed boost alongside invincibility."
