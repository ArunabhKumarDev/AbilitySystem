## AirDash_Ability.gd
## Short horizontal dash while airborne.
class_name AirDash_Ability
extends Object

const ABILITY_NAME := "AirDash"

static func _can_use(player: Node2D) -> bool:
	if player.is_on_cooldown(ABILITY_NAME):
		return false
	var power_cost: float = player.get_meta("AirDash_power_cost", 8.0)
	if power_cost > 0.0 and player.power < power_cost:
		return false
	return true

static func trigger(player: Node2D) -> Dictionary:
	if not player.is_airborne:
		return {"success": false, "reason": "must_be_airborne"}
	if not _can_use(player):
		return {"success": false, "reason": "on_cooldown_or_no_power"}

	var power_cost: float        = player.get_meta("AirDash_power_cost", 8.0)
	var cooldown_duration: float = player.get_meta("AirDash_cooldown_duration", 3.0)

	player.spend_power(power_cost)
	player.set_cooldown(ABILITY_NAME, cooldown_duration)

	player.apply_buff("air_dash", 0.25)
	player.apply_buff("speed_boost", 0.25, 12.0)
	return {"success": true, "dashed": true}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	return "Dash horizontally while airborne."
