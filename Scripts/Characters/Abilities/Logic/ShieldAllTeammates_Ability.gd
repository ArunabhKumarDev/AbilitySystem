## ShieldAllTeammates_Ability.gd
## Applies a shield to every teammate.
class_name ShieldAllTeammates_Ability
extends Object

const ABILITY_NAME := "ShieldAllTeammates"

static func _can_use(player: Node2D) -> bool:
	if player.is_on_cooldown(ABILITY_NAME):
		return false
	var power_cost: float = player.get_meta("ShieldAllTeammates_power_cost", 30.0)
	if power_cost > 0.0 and player.power < power_cost:
		return false
	return true

static func trigger(player: Node2D) -> Dictionary:
	if not _can_use(player):
		return {"success": false, "reason": "on_cooldown_or_no_power"}

	var power_cost: float        = player.get_meta("ShieldAllTeammates_power_cost", 30.0)
	var cooldown_duration: float = player.get_meta("ShieldAllTeammates_cooldown_duration", 22.0)
	var effect_value: float      = player.get_meta("ShieldAllTeammates_effect_value", 25.0)

	player.spend_power(power_cost)
	player.set_cooldown(ABILITY_NAME, cooldown_duration)

	var val: float = effect_value * (1.0 + 0.10 * player.upgrade_level)
	for teammate in player.teammates:
		teammate.add_shield(val)
	return {"success": true, "shield_hp_each": val,
			"teammates_affected": player.teammates.size()}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	var effect_value: float = player.get_meta("ShieldAllTeammates_effect_value", 25.0)
	return "Shield all teammates for %.0f HP." % effect_value
