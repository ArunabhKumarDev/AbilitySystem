## BlazeLyraComboSpeed_Ability.gd
## Blaze's combination ability (paired with Lyra) — a speed burst applied
## to both Blaze and Lyra.
##
## Same effect shape as SpeedBurst_Ability, but kept as its own script
## rather than reusing SpeedBurst_Ability, since Blaze uses BOTH abilities
## on himself: sharing a class would mean sharing the same meta-key
## namespace and the same cooldown key, so configuring this one would
## overwrite his main SpeedBurst's own settings on the same player.
class_name BlazeLyraComboSpeed_Ability
extends Object

const ABILITY_NAME := "BlazeLyraComboSpeed"

static func _can_use(player: Node2D) -> bool:
	if player.is_on_cooldown(ABILITY_NAME):
		return false
	var power_cost: float = player.get_meta("BlazeLyraComboSpeed_power_cost", 20.0)
	if power_cost > 0.0 and player.power < power_cost:
		return false
	return true

static func trigger(player: Node2D) -> Dictionary:
	if not _can_use(player):
		return {"success": false, "reason": "on_cooldown_or_no_power"}

	var power_cost: float        = player.get_meta("BlazeLyraComboSpeed_power_cost", 20.0)
	var cooldown_duration: float = player.get_meta("BlazeLyraComboSpeed_cooldown_duration", 30.0)
	var speed_bonus: float       = player.get_meta("BlazeLyraComboSpeed_speed_bonus", 3.0)
	var duration: float          = player.get_meta("BlazeLyraComboSpeed_duration", 5.0)

	player.spend_power(power_cost)
	player.set_cooldown(ABILITY_NAME, cooldown_duration)

	player.apply_buff("speed_boost", duration, speed_bonus)
	for mate in player.teammates:
		if mate.character_name == "Lyra":
			mate.apply_buff("speed_boost", duration, speed_bonus)

	return {"success": true, "speed_bonus": speed_bonus, "duration": duration}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	return "Speed boost shared with Lyra."
