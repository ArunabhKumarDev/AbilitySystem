## ExcessHealToShield_Ability.gd
## Restore HP; any healing beyond max HP converts into shield HP instead.
class_name ExcessHealToShield_Ability
extends Object

const ABILITY_NAME := "ExcessHealToShield"

static func _can_use(player: Node2D) -> bool:
	if player.is_on_cooldown(ABILITY_NAME):
		return false
	var power_cost: float = player.get_meta("ExcessHealToShield_power_cost", 18.0)
	if power_cost > 0.0 and player.power < power_cost:
		return false
	return true

static func trigger(player: Node2D) -> Dictionary:
	if not _can_use(player):
		return {"success": false, "reason": "on_cooldown_or_no_power"}

	var power_cost: float        = player.get_meta("ExcessHealToShield_power_cost", 18.0)
	var cooldown_duration: float = player.get_meta("ExcessHealToShield_cooldown_duration", 14.0)
	var heal_amount: float       = player.get_meta("ExcessHealToShield_heal_amount", 35.0)

	player.spend_power(power_cost)
	player.set_cooldown(ABILITY_NAME, cooldown_duration)

	var amount: float = heal_amount * (1.0 + 0.20 * player.upgrade_level)
	var r: Dictionary = player.heal(amount)
	var result := {"success": true, "healed": r["healed"]}
	if r["excess"] > 0.0:
		player.add_shield(r["excess"])
		result["shield_gained"] = r["excess"]
	return result

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	return "Restore HP; overheal becomes a shield."
