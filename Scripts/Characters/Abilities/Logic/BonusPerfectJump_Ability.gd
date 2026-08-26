## BonusPerfectJump_Ability.gd
## Passive — grants a score bonus multiplier while airborne.
## update_points() calls the same placeholder add_score() as DoubleCoinValue.
class_name BonusPerfectJump_Ability
extends Object

const ABILITY_NAME := "BonusPerfectJump"

static func trigger(player: Node2D) -> Dictionary:
	if not player.is_airborne:
		return {"success": false, "reason": "not_airborne"}
	var multiplier: float = player.get_meta("BonusPerfectJump_multiplier", 1.5)
	var duration: float   = player.get_meta("BonusPerfectJump_duration", 999.0)
	var mult: float = multiplier + 0.25 * player.upgrade_level
	player.apply_buff("perfect_jump_bonus", duration, mult)
	return {"success": true, "multiplier": mult}

static func update_points(player: Node2D) -> void:
	if not player.has_method("add_score"):
		return
	if player.has_buff("perfect_jump_bonus") and player.is_airborne:
		player.add_score(0.5 * player.get_buff_value("perfect_jump_bonus"))

static func get_description(player: Node2D) -> String:
	var multiplier: float = player.get_meta("BonusPerfectJump_multiplier", 1.5)
	return "Score bonus x%.1f while airborne." % multiplier
