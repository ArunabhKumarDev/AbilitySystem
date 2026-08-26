## HealAllTeammates_Ability.gd
## Restores HP to every teammate.
class_name HealAllTeammates_Ability
extends Object

const ABILITY_NAME := "HealAllTeammates"

static func _can_use(player: Node2D) -> bool:
	if player.is_on_cooldown(ABILITY_NAME):
		return false
	var power_cost: float = player.get_meta("HealAllTeammates_power_cost", 35.0)
	if power_cost > 0.0 and player.power < power_cost:
		return false
	return true

static func trigger(player: Node2D) -> Dictionary:
	if not _can_use(player):
		return {"success": false, "reason": "on_cooldown_or_no_power"}

	var power_cost: float        = player.get_meta("HealAllTeammates_power_cost", 35.0)
	var cooldown_duration: float = player.get_meta("HealAllTeammates_cooldown_duration", 20.0)
	var heal_amount: float       = player.get_meta("HealAllTeammates_heal_amount", 30.0)

	player.spend_power(power_cost)
	player.set_cooldown(ABILITY_NAME, cooldown_duration)

	var val: float   = heal_amount * (1.0 + 0.10 * player.upgrade_level)
	var total: float = 0.0
	for teammate in player.teammates:
		total += teammate.heal(val)["healed"]
	return {"success": true, "hp_each": val, "total_healed": total,
			"teammates_healed": player.teammates.size()}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	var heal_amount: float = player.get_meta("HealAllTeammates_heal_amount", 30.0)
	return "Restore %.0f HP to all teammates." % heal_amount
