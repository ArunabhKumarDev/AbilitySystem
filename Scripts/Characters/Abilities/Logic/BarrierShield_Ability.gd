## BarrierShield_Ability.gd
## Gain a shield with its own HP pool.
##
## STATIC — no instance, no instance fields. Every tunable value is read
## from `player`'s metadata (set by the character's handler in setup()),
## with the value passed to get_meta() as the factory default. Meta keys
## are namespaced with the ability name to avoid collisions with other
## abilities' meta on the same player.
class_name BarrierShield_Ability
extends Object

const ABILITY_NAME := "BarrierShield"

static func _can_use(player: Node2D) -> bool:
	if player.is_on_cooldown(ABILITY_NAME):
		return false
	var power_cost: float = player.get_meta("BarrierShield_power_cost", 20.0)
	if power_cost > 0.0 and player.power < power_cost:
		return false
	return true

static func trigger(player: Node2D) -> Dictionary:
	if not _can_use(player):
		return {"success": false, "reason": "on_cooldown_or_no_power"}

	var power_cost: float        = player.get_meta("BarrierShield_power_cost", 20.0)
	var cooldown_duration: float = player.get_meta("BarrierShield_cooldown_duration", 10.0)
	var shield_hp: float         = player.get_meta("BarrierShield_shield_hp", 65.0)

	player.spend_power(power_cost)
	player.set_cooldown(ABILITY_NAME, cooldown_duration)

	var amount: float = shield_hp * (1.0 + 0.20 * player.upgrade_level)
	player.add_shield(amount)
	return {"success": true, "shield_hp": amount}

static func update_points(player: Node2D) -> void:
	pass  # no direct score effect

static func get_description(player: Node2D) -> String:
	var shield_hp: float = player.get_meta("BarrierShield_shield_hp", 65.0)
	return "Gain a shield with %.0f HP." % shield_hp
