## MissedCoinCollect_Ability.gd
## Passive — recovers recently missed coins. Reads `player.missed_coins`
## directly (assumption — see earlier note on context-data properties).
class_name MissedCoinCollect_Ability
extends Object

const ABILITY_NAME := "MissedCoinCollect"

static func trigger(player: Node2D) -> Dictionary:
	var coin_count: int = player.get_meta("MissedCoinCollect_coin_count", 8)
	var limit: int = coin_count + player.upgrade_level * 2
	var missed_val = player.get("missed_coins")
	var missed: int = missed_val if missed_val != null else limit
	var recovered: int = mini(missed, limit)
	player.add_coins(recovered)
	return {"success": true, "missed_recovered": recovered}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	var coin_count: int = player.get_meta("MissedCoinCollect_coin_count", 8)
	return "Recover up to %d recently missed coins." % coin_count
