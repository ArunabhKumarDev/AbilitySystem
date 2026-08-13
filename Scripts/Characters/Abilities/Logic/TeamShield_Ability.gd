## TeamShield_Ability.gd
## Shield every teammate (and self) for a flat amount.
class_name TeamShield_Ability
extends Object

const ABILITY_NAME := "TeamShield"

static func _can_use(player: Node2D) -> bool:
	if player.is_on_cooldown(ABILITY_NAME):
		return false
	var power_cost: float = player.get_meta("TeamShield_power_cost", 30.0)
	if power_cost > 0.0 and player.power < power_cost:
		return false
	return true

static func trigger(player: Node2D) -> Dictionary:
	if not _can_use(player):
		return {"success": false, "reason": "on_cooldown_or_no_power"}

	var power_cost: float        = player.get_meta("TeamShield_power_cost", 30.0)
	var cooldown_duration: float = player.get_meta("TeamShield_cooldown_duration", 25.0)
	var team_shield_hp: float    = player.get_meta("TeamShield_team_shield_hp", 30.0)

	player.spend_power(power_cost)
	player.set_cooldown(ABILITY_NAME, cooldown_duration)

	var amount: float = team_shield_hp * (1.0 + 0.15 * player.upgrade_level)
	for teammate in player.teammates:
		teammate.add_shield(amount)
	player.add_shield(amount)
	return {"success": true, "shield_hp_each": amount,
			"teammates_shielded": player.teammates.size()}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	var val: float = player.get_meta("TeamShield_team_shield_hp", 30.0)
	return "Shield all teammates for %.0f HP." % val
