## NextHitBlock_Ability.gd
## Absorbs the next N hits via a hit-counter, NOT the generic invincibility
## flag — this deliberately does not call apply_buff("invincibility", ...).
class_name NextHitBlock_Ability
extends Object

const ABILITY_NAME := "NextHitBlock"

static func _can_use(player: Node2D) -> bool:
	if player.is_on_cooldown(ABILITY_NAME):
		return false
	var power_cost: float = player.get_meta("NextHitBlock_power_cost", 15.0)
	if power_cost > 0.0 and player.power < power_cost:
		return false
	return true

static func trigger(player: Node2D) -> Dictionary:
	if not _can_use(player):
		return {"success": false, "reason": "on_cooldown_or_no_power"}

	var power_cost: float        = player.get_meta("NextHitBlock_power_cost", 15.0)
	var cooldown_duration: float = player.get_meta("NextHitBlock_cooldown_duration", 20.0)
	var hit_blocks: int          = player.get_meta("NextHitBlock_hit_blocks", 1)

	player.spend_power(power_cost)
	player.set_cooldown(ABILITY_NAME, cooldown_duration)

	var blocks: int = hit_blocks + player.upgrade_level
	player.invincibility_blocks = blocks
	player.apply_buff("next_hit_guard", 60.0)  # cosmetic marker only
	return {"success": true, "hit_blocks": blocks}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	var hit_blocks: int = player.get_meta("NextHitBlock_hit_blocks", 1)
	return "Absorb the next %d hit(s)." % hit_blocks
