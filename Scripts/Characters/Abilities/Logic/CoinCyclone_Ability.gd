## CoinCyclone_Ability.gd
## Pulls in every nearby coin instantly. Reads `player.nearby_coins`
## directly (assumption — see earlier note on context-data properties).
class_name CoinCyclone_Ability
extends Object

const ABILITY_NAME := "CoinCyclone"

static func _can_use(player: Node2D) -> bool:
	if player.is_on_cooldown(ABILITY_NAME):
		return false
	var power_cost: float = player.get_meta("CoinCyclone_power_cost", 25.0)
	if power_cost > 0.0 and player.power < power_cost:
		return false
	return true

static func trigger(player: Node2D) -> Dictionary:
	if not _can_use(player):
		return {"success": false, "reason": "on_cooldown_or_no_power"}

	var power_cost: float        = player.get_meta("CoinCyclone_power_cost", 25.0)
	var cooldown_duration: float = player.get_meta("CoinCyclone_cooldown_duration", 14.0)
	var duration: float          = player.get_meta("CoinCyclone_duration", 6.0)
	var base_coins: int          = player.get_meta("CoinCyclone_base_coins", 18)

	player.spend_power(power_cost)
	player.set_cooldown(ABILITY_NAME, cooldown_duration)

	var dur: float = duration + player.upgrade_level
	var nearby_val = player.get("nearby_coins")
	var nearby: int = (nearby_val if nearby_val != null else base_coins) + player.upgrade_level * 3
	player.add_coins(nearby)
	player.apply_buff("coin_cyclone", dur)
	return {"success": true, "coins_collected": nearby, "duration": dur}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	var duration: float = player.get_meta("CoinCyclone_duration", 6.0)
	return "Collect all coins in range for %.0f seconds." % duration
