## Hover_Ability.gd
## Float in place for a short duration. Airborne check happens before any
## power/cooldown is spent, so a failed attempt costs nothing.
class_name Hover_Ability
extends Object

const ABILITY_NAME := "Hover"

static func _can_use(player: Node2D) -> bool:
	if player.is_on_cooldown(ABILITY_NAME):
		return false
	var power_cost: float = player.get_meta("Hover_power_cost", 12.0)
	if power_cost > 0.0 and player.power < power_cost:
		return false
	return true

static func trigger(player: Node2D) -> Dictionary:
	if not player.is_airborne:
		return {"success": false, "reason": "must_be_airborne"}
	if not _can_use(player):
		return {"success": false, "reason": "on_cooldown_or_no_power"}

	var power_cost: float        = player.get_meta("Hover_power_cost", 12.0)
	var cooldown_duration: float = player.get_meta("Hover_cooldown_duration", 6.0)
	var hover_duration: float    = player.get_meta("Hover_hover_duration", 2.5)

	player.spend_power(power_cost)
	player.set_cooldown(ABILITY_NAME, cooldown_duration)

	var dur: float = hover_duration + player.upgrade_level * 0.5
	player.apply_buff("hover", dur)
	return {"success": true, "duration": dur}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	var hover_duration: float = player.get_meta("Hover_hover_duration", 2.5)
	return "Float in place for %.1f seconds." % hover_duration
