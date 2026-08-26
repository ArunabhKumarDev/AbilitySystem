## ReduceTeammateCd_Ability.gd
## Passive — chips away at every teammate's active cooldowns.
class_name ReduceTeammateCd_Ability
extends Object

const ABILITY_NAME := "ReduceTeammateCd"

static func trigger(player: Node2D) -> Dictionary:
	var effect_value: float = player.get_meta("ReduceTeammateCd_effect_value", 3.0)
	var val: float = effect_value * (1.0 + 0.10 * player.upgrade_level)
	for teammate in player.teammates:
		for k in teammate.cooldowns.keys():
			teammate.cooldowns[k] = maxf(0.0, teammate.cooldowns[k] - val)
	return {"success": true, "cd_reduced_by": val,
			"teammates_affected": player.teammates.size()}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	var effect_value: float = player.get_meta("ReduceTeammateCd_effect_value", 3.0)
	return "Cut all teammate cooldowns by %.0f seconds." % effect_value
