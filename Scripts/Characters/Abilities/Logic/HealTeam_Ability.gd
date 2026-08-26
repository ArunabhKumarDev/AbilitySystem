## HealTeam_Ability.gd
## Large team-wide heal — revival stand-in until real revival logic exists.
class_name HealTeam_Ability
extends Object

const ABILITY_NAME := "HealTeam"

static func _can_use(player: Node2D) -> bool:
	if player.is_on_cooldown(ABILITY_NAME):
		return false
	var power_cost: float = player.get_meta("HealTeam_power_cost", 50.0)
	if power_cost > 0.0 and player.power < power_cost:
		return false
	return true

static func trigger(player: Node2D) -> Dictionary:
	if not _can_use(player):
		return {"success": false, "reason": "on_cooldown_or_no_power"}

	var power_cost: float        = player.get_meta("HealTeam_power_cost", 50.0)
	var cooldown_duration: float = player.get_meta("HealTeam_cooldown_duration", 60.0)
	var heal_amount: float       = player.get_meta("HealTeam_heal_amount", 100.0)
	var team_fraction: float     = player.get_meta("HealTeam_team_fraction", 0.6)

	player.spend_power(power_cost)
	player.set_cooldown(ABILITY_NAME, cooldown_duration)

	var s_amt: float = heal_amount * (1.0 + 0.10 * player.upgrade_level)
	var t_amt: float = s_amt * team_fraction
	var total: float = 0.0
	for teammate in player.teammates:
		total += teammate.heal(t_amt)["healed"]
	total += player.heal(s_amt)["healed"]
	return {"success": true, "total_healed": total,
			"teammates_healed": player.teammates.size(),
			"revival_note": "defeated_teammates_restored"}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	return "Large team heal (revival stand-in)."
