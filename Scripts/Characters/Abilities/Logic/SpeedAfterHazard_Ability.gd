## SpeedAfterHazard_Ability.gd
## Passive — speed boost after dodging a hazard (bigger if timed well).
## Reads `player.hazard_avoided` directly (assumption — see earlier note).
class_name SpeedAfterHazard_Ability
extends Object

const ABILITY_NAME := "SpeedAfterHazard"

static func trigger(player: Node2D) -> Dictionary:
	var speed_bonus: float = player.get_meta("SpeedAfterHazard_speed_bonus", 3.0)
	var duration: float    = player.get_meta("SpeedAfterHazard_duration", 3.0)
	var bonus: float = speed_bonus + player.upgrade_level * 0.5
	var dur: float   = duration    + player.upgrade_level * 0.5
	var avoided_val   = player.get("hazard_avoided")
	var avoided: bool = avoided_val if avoided_val != null else false
	var actual: float = bonus * (1.5 if avoided else 1.0)
	player.apply_buff("speed_boost", dur, actual)
	return {"success": true, "speed_bonus": actual, "hazard_avoided": avoided}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	var speed_bonus: float = player.get_meta("SpeedAfterHazard_speed_bonus", 3.0)
	return "Gain +%.0f speed (more if you dodged a hazard)." % speed_bonus
