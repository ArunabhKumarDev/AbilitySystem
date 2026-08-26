## DoubleJump_Ability.gd
## Grants one extra jump while airborne.
class_name DoubleJump_Ability
extends Object

const ABILITY_NAME := "DoubleJump"

static func _can_use(player: Node2D) -> bool:
	var power_cost: float = player.get_meta("DoubleJump_power_cost", 5.0)
	if power_cost > 0.0 and player.power < power_cost:
		return false
	return true

static func trigger(player: Node2D) -> Dictionary:
	if not _can_use(player):
		return {"success": false, "reason": "no_power"}

	var power_cost: float = player.get_meta("DoubleJump_power_cost", 5.0)
	player.spend_power(power_cost)

	var extra: int = 1 + player.upgrade_level
	player.max_jumps += extra
	var jumped: bool = player.jump()
	if not jumped:
		player.max_jumps -= extra
		player.restore_power(power_cost)
		return {"success": false, "reason": "no_jumps_remaining"}
	return {"success": true, "jumped": true, "max_jumps": player.max_jumps}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	return "Jump once more while airborne."
