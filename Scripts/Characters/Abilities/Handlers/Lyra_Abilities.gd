## Lyra_Abilities.gd
## Handler for Lyra — aerial specialist.
##
## ABILITY SET
##   Main:        DoubleJump  (becomes triple jump at upgrade 2+)
##   Passive:     BonusPerfectJump
##   Race Trait:  Hover
##   Combination: AirDash (with Blaze)
class_name Lyra_Abilities
extends AbilityHandler

enum Names { DOUBLE_JUMP, BONUS_PERFECT_JUMP, HOVER, AIR_DASH }

func setup() -> void:
	player.set_meta("DoubleJump_power_cost", 5.0)

	player.set_meta("BonusPerfectJump_multiplier", 1.5)

	player.set_meta("Hover_hover_duration", 2.5)
	player.set_meta("Hover_power_cost", 12.0)
	player.set_meta("Hover_cooldown_duration", 6.0)

	player.set_meta("AirDash_power_cost", 8.0)
	player.set_meta("AirDash_cooldown_duration", 3.0)

	main_ability        = DoubleJump_Ability
	passive_ability     = BonusPerfectJump_Ability
	race_trait_ability  = Hover_Ability
	combination_ability = AirDash_Ability


func trigger_main_ability(context: Dictionary = {}) -> Dictionary:
	var result: Dictionary = DoubleJump_Ability.trigger(player)
	if player and player.upgrade_level >= 2 and result.get("success"):
		player.max_jumps = 3
		result["max_jumps"] = 3
		result["triple_jump_note"] = "upgrade_2_grants_triple_jump"
	return result


func trigger_passive(context: Dictionary = {}) -> Dictionary:
	if player and player.is_airborne:
		return BonusPerfectJump_Ability.trigger(player)
	return {"success": false, "reason": "not_airborne"}


func trigger_combination(context: Dictionary = {}) -> Dictionary:
	var partner: String = context.get("paired_character", "")
	if partner == "Blaze":
		return AirDash_Ability.trigger(player)
	return {"success": false, "reason": "requires_Blaze"}


func on_coin_collected(amount: int) -> void:
	if player and player.is_airborne and player.upgrade_level >= 1:
		player.jump_count = maxi(0, player.jump_count - 1)


func on_land() -> void:
	if player and player.upgrade_level >= 1:
		player.apply_buff("bounce_armed", 0.5)
