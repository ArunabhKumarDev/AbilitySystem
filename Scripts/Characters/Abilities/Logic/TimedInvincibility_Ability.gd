## TimedInvincibility_Ability.gd
## Classic i-frames for a set duration.
class_name TimedInvincibility_Ability
extends Object

const ABILITY_NAME := "TimedInvincibility"

static func _can_use(player: Node2D) -> bool:
	if player.is_on_cooldown(ABILITY_NAME):
		return false
	var power_cost: float = player.get_meta("TimedInvincibility_power_cost", 30.0)
	if power_cost > 0.0 and player.power < power_cost:
		return false
	return true

static func trigger(player: Node2D) -> Dictionary:
	if not _can_use(player):
		return {"success": false, "reason": "on_cooldown_or_no_power"}

	var power_cost: float        = player.get_meta("TimedInvincibility_power_cost", 30.0)
	var cooldown_duration: float = player.get_meta("TimedInvincibility_cooldown_duration", 18.0)
	var duration: float          = player.get_meta("TimedInvincibility_duration", 3.5)

	player.spend_power(power_cost)
	player.set_cooldown(ABILITY_NAME, cooldown_duration)

	var dur: float = duration + player.upgrade_level * 0.5
	player.apply_buff("invincibility", dur)
	return {"success": true, "duration": dur}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	var duration: float = player.get_meta("TimedInvincibility_duration", 3.5)
	return "Become invincible for %.0f seconds." % duration
