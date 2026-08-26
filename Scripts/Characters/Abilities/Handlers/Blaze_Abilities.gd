## Blaze_Abilities.gd
## Handler for Blaze — fastest runner, built around momentum.
##
## ABILITY SET
##   Main:        SpeedBurst
##   Passive:     SpeedAfterHazard
##   Race Trait:  ForwardDash
##   Combination: BlazeLyraComboSpeed (with Lyra) — a separate ability
##                script from SpeedBurst, since Blaze uses speed-burst
##                logic twice on himself; sharing SpeedBurst_Ability here
##                would mean both uses fight over the same meta keys and
##                the same cooldown key on Blaze's own player node.
class_name Blaze_Abilities
extends AbilityHandler

enum Names { SPEED_BURST, SPEED_AFTER_HAZARD, FORWARD_DASH, BLAZE_LYRA_COMBO_SPEED }

func setup() -> void:
	player.set_meta("SpeedBurst_speed_bonus", 5.0)
	player.set_meta("SpeedBurst_duration", 4.0)
	player.set_meta("SpeedBurst_power_cost", 10.0)
	player.set_meta("SpeedBurst_cooldown_duration", 8.0)

	player.set_meta("SpeedAfterHazard_speed_bonus", 3.0)
	player.set_meta("SpeedAfterHazard_duration", 3.0)

	player.set_meta("ForwardDash_dash_distance", 6.0)
	player.set_meta("ForwardDash_power_cost", 8.0)
	player.set_meta("ForwardDash_cooldown_duration", 3.5)

	player.set_meta("BlazeLyraComboSpeed_speed_bonus", 3.0)
	player.set_meta("BlazeLyraComboSpeed_duration", 5.0)
	player.set_meta("BlazeLyraComboSpeed_power_cost", 20.0)
	player.set_meta("BlazeLyraComboSpeed_cooldown_duration", 30.0)

	main_ability        = SpeedBurst_Ability
	passive_ability     = SpeedAfterHazard_Ability
	race_trait_ability  = ForwardDash_Ability
	combination_ability = BlazeLyraComboSpeed_Ability


func trigger_main_ability(context: Dictionary = {}) -> Dictionary:
	var result: Dictionary = SpeedBurst_Ability.trigger(player)
	if result.get("success") and player and player.upgrade_level >= 2:
		player.apply_buff("destroy_on_contact", 0.5)
		result["breaks_obstacle"] = true
	return result


func trigger_combination(context: Dictionary = {}) -> Dictionary:
	var partner: String = context.get("paired_character", "")
	if partner == "Lyra":
		return BlazeLyraComboSpeed_Ability.trigger(player)
	return {"success": false, "reason": "requires_Lyra"}


func on_land() -> void:
	if player and player.upgrade_level >= 1:
		player.apply_buff("speed_boost", 1.0, 2.0)
