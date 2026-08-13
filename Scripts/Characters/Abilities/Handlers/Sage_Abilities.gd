## Sage_Abilities.gd
## Handler for Sage — team healer/buffer.
##
## ABILITY SET
##   Main:        HealAllTeammates
##   Passive:     ReduceTeammateCd
##   Race Trait:  ShieldAllTeammates
##   Combination: HealTeam (with Aria) — revival stand-in
class_name Sage_Abilities
extends AbilityHandler

enum Names { HEAL_ALL_TEAMMATES, REDUCE_TEAMMATE_CD, SHIELD_ALL_TEAMMATES, HEAL_TEAM }

func setup() -> void:
	player.set_meta("HealAllTeammates_heal_amount", 30.0)
	player.set_meta("HealAllTeammates_power_cost", 35.0)
	player.set_meta("HealAllTeammates_cooldown_duration", 20.0)

	player.set_meta("ReduceTeammateCd_effect_value", 3.0)

	player.set_meta("ShieldAllTeammates_effect_value", 25.0)
	player.set_meta("ShieldAllTeammates_power_cost", 30.0)
	player.set_meta("ShieldAllTeammates_cooldown_duration", 22.0)

	player.set_meta("HealTeam_heal_amount", 100.0)
	player.set_meta("HealTeam_power_cost", 50.0)
	player.set_meta("HealTeam_cooldown_duration", 60.0)

	main_ability        = HealAllTeammates_Ability
	passive_ability     = ReduceTeammateCd_Ability
	race_trait_ability  = ShieldAllTeammates_Ability
	combination_ability = HealTeam_Ability


func trigger_main_ability(context: Dictionary = {}) -> Dictionary:
	var result: Dictionary = HealAllTeammates_Ability.trigger(player)
	if result.get("success") and player and player.upgrade_level >= 2:
		for mate in player.teammates:
			mate.emit_signal("ability_triggered", "sage_cleanse", {"cleanse": 1})
		result["cleanse_applied"] = true
	return result


func trigger_combination(context: Dictionary = {}) -> Dictionary:
	var partner: String = context.get("paired_character", "")
	if partner == "Aria":
		return HealTeam_Ability.trigger(player)
	return {"success": false, "reason": "requires_Aria"}


func on_coin_collected(amount: int) -> void:
	if player:
		player.restore_power(float(amount) * 0.5)
