## ForwardDash_Ability.gd
## Quick forward dash.
class_name ForwardDash_Ability
extends Object

const ABILITY_NAME := "ForwardDash"

static func _can_use(player: Node2D) -> bool:
	if player.is_on_cooldown(ABILITY_NAME):
		return false
	var power_cost: float = player.get_meta("ForwardDash_power_cost", 8.0)
	if power_cost > 0.0 and player.power < power_cost:
		return false
	return true

static func trigger(player: Node2D) -> Dictionary:
	if not _can_use(player):
		return {"success": false, "reason": "on_cooldown_or_no_power"}

	var power_cost: float        = player.get_meta("ForwardDash_power_cost", 8.0)
	var cooldown_duration: float = player.get_meta("ForwardDash_cooldown_duration", 3.5)
	var dash_distance: float     = player.get_meta("ForwardDash_dash_distance", 6.0)

	player.spend_power(power_cost)
	player.set_cooldown(ABILITY_NAME, cooldown_duration)

	var dist: float = dash_distance + player.upgrade_level * 1.0
	player.apply_buff("dashing", 0.2, dist)
	return {"success": true, "dash_distance": dist}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	var dash_distance: float = player.get_meta("ForwardDash_dash_distance", 6.0)
	return "Dash forward %.0f units." % dash_distance
