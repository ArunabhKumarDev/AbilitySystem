## DoubleCoinValue_Ability.gd
## Coins collected while active are worth more.
##
## NOTE FOR GODEYE: update_points() calls add_score() — still a placeholder
## on CharacterBase pending your real points API.
class_name DoubleCoinValue_Ability
extends Object

const ABILITY_NAME := "DoubleCoinValue"

static func _can_use(player: Node2D) -> bool:
	if player.is_on_cooldown(ABILITY_NAME):
		return false
	var power_cost: float = player.get_meta("DoubleCoinValue_power_cost", 20.0)
	if power_cost > 0.0 and player.power < power_cost:
		return false
	return true

static func trigger(player: Node2D) -> Dictionary:
	if not _can_use(player):
		return {"success": false, "reason": "on_cooldown_or_no_power"}

	var power_cost: float        = player.get_meta("DoubleCoinValue_power_cost", 20.0)
	var cooldown_duration: float = player.get_meta("DoubleCoinValue_cooldown_duration", 18.0)
	var multiplier: float        = player.get_meta("DoubleCoinValue_multiplier", 2.0)
	var duration: float          = player.get_meta("DoubleCoinValue_duration", 10.0)

	player.spend_power(power_cost)
	player.set_cooldown(ABILITY_NAME, cooldown_duration)

	var mult: float = multiplier + 0.25 * player.upgrade_level
	var dur: float  = duration   + player.upgrade_level
	player.apply_buff("coin_value_multiplier", dur, mult)
	return {"success": true, "multiplier": mult, "duration": dur}

static func update_points(player: Node2D) -> void:
	if not player.has_method("add_score"):
		return
	if not player.has_buff("coin_value_multiplier"):
		return
	var coins_val = player.get("coins_collected_this_frame")
	var coins_this_frame: int = coins_val if coins_val != null else 0
	if coins_this_frame > 0:
		var mult: float = player.get_buff_value("coin_value_multiplier")
		player.add_score(coins_this_frame * (mult - 1.0) * 10.0)

static func get_description(player: Node2D) -> String:
	var multiplier: float = player.get_meta("DoubleCoinValue_multiplier", 2.0)
	var duration: float   = player.get_meta("DoubleCoinValue_duration", 10.0)
	return "Coins worth x%.1f for %.0f seconds." % [multiplier, duration]
