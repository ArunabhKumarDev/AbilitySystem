## HealOnCoin_Ability.gd
## Passive — restores a small amount of HP each time a coin is collected.
class_name HealOnCoin_Ability
extends Object

const ABILITY_NAME := "HealOnCoin"

static func trigger(player: Node2D) -> Dictionary:
	var heal_amount: float = player.get_meta("HealOnCoin_heal_amount", 3.0)
	var amount: float = heal_amount * (1.0 + 0.10 * player.upgrade_level)
	var r: Dictionary = player.heal(amount)
	return {"success": true, "healed": r["healed"]}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	var heal_amount: float = player.get_meta("HealOnCoin_heal_amount", 3.0)
	return "Passively restore %.0f HP per coin collected." % heal_amount
