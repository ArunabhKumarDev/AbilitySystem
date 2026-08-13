## Nova_Abilities.gd
## Handler for Nova — coin-focused runner.
##
## ABILITY SET
##   Main:        CoinCyclone
##   Passive:     MissedCoinCollect
##   Race Trait:  DoubleCoinValue
##   Combination: HealOverTime (with Aria) — stub, see the script's header.
class_name Nova_Abilities
extends AbilityHandler

enum Names { COIN_CYCLONE, MISSED_COIN_COLLECT, DOUBLE_COIN_VALUE, HEAL_OVER_TIME }

func setup() -> void:
	player.set_meta("CoinCyclone_duration", 6.0)
	player.set_meta("CoinCyclone_base_coins", 18)
	player.set_meta("CoinCyclone_power_cost", 25.0)
	player.set_meta("CoinCyclone_cooldown_duration", 14.0)

	player.set_meta("MissedCoinCollect_coin_count", 8)

	player.set_meta("DoubleCoinValue_multiplier", 2.0)
	player.set_meta("DoubleCoinValue_duration", 10.0)
	player.set_meta("DoubleCoinValue_power_cost", 20.0)
	player.set_meta("DoubleCoinValue_cooldown_duration", 18.0)

	main_ability        = CoinCyclone_Ability
	passive_ability     = MissedCoinCollect_Ability
	race_trait_ability  = DoubleCoinValue_Ability
	combination_ability = HealOverTime_Ability  # stub


func trigger_main_ability(context: Dictionary = {}) -> Dictionary:
	var result: Dictionary = CoinCyclone_Ability.trigger(player)
	if result.get("success") and player and player.upgrade_level >= 1:
		MissedCoinCollect_Ability.trigger(player)
		result["also_recovered_missed"] = true
	return result


func trigger_combination(context: Dictionary = {}) -> Dictionary:
	var partner: String = context.get("paired_character", "")
	if partner == "Aria":
		return HealOverTime_Ability.trigger(player)  # stub — see script header
	return {"success": false, "reason": "requires_Aria"}


func on_coin_collected(amount: int) -> void:
	if player and amount >= 5:
		player.set_cooldown("MissedCoinCollect", 0.0)
