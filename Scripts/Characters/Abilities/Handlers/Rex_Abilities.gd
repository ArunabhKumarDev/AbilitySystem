## Rex_Abilities.gd
## Handler for Rex — bruiser, charges through hazards.
##
## ABILITY SET
##   Main:        TimedInvincibility
##   Passive:     DestroyObstacle
##   Race Trait:  NextHitBlock
##   Combination: RexBlazeComboSpeed (with Blaze) — free speed boost
##                piggybacked onto invincibility; kept as its own script
##                rather than reusing SpeedBurst_Ability, same reasoning
##                as Blaze's BlazeLyraComboSpeed_Ability.
class_name Rex_Abilities
extends AbilityHandler

enum Names { TIMED_INVINCIBILITY, DESTROY_OBSTACLE, NEXT_HIT_BLOCK, REX_BLAZE_COMBO_SPEED }

func setup() -> void:
	player.set_meta("TimedInvincibility_duration", 3.5)
	player.set_meta("TimedInvincibility_power_cost", 30.0)
	player.set_meta("TimedInvincibility_cooldown_duration", 18.0)

	player.set_meta("DestroyObstacle_duration", 3.5)

	player.set_meta("NextHitBlock_hit_blocks", 1)
	player.set_meta("NextHitBlock_power_cost", 15.0)
	player.set_meta("NextHitBlock_cooldown_duration", 20.0)

	player.set_meta("RexBlazeComboSpeed_speed_bonus", 6.0)
	player.set_meta("RexBlazeComboSpeed_duration", 3.5)

	main_ability        = TimedInvincibility_Ability
	passive_ability     = DestroyObstacle_Ability
	race_trait_ability  = NextHitBlock_Ability
	combination_ability = RexBlazeComboSpeed_Ability


func trigger_main_ability(context: Dictionary = {}) -> Dictionary:
	var result: Dictionary = TimedInvincibility_Ability.trigger(player)
	if result.get("success") and player:
		DestroyObstacle_Ability.trigger(player)
		result["hazard_destroy_armed"] = true
	return result


func trigger_passive(context: Dictionary = {}) -> Dictionary:
	if player and player.is_invincible:
		return DestroyObstacle_Ability.trigger(player)
	return {"success": false, "reason": "not_invincible"}


func trigger_combination(context: Dictionary = {}) -> Dictionary:
	var partner: String = context.get("paired_character", "")
	if partner == "Blaze":
		var result: Dictionary = TimedInvincibility_Ability.trigger(player)
		if result.get("success") and player:
			RexBlazeComboSpeed_Ability.trigger(player)
			result["speed_boost_applied"] = true
		return result
	return {"success": false, "reason": "requires_Blaze"}


func on_land() -> void:
	if player and player.upgrade_level >= 1:
		player.emit_signal("ability_triggered", "rex_shockwave",
			{"radius": 2.0 + player.upgrade_level})
