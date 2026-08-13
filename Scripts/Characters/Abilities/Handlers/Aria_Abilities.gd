## Aria_Abilities.gd
## Handler for Aria — tanky support runner.
##
## ABILITY SET
##   Main:        BarrierShield        — absorbs incoming damage
##   Passive:     HealOnCoin           — each coin restores a little HP
##   Race Trait:  ExcessHealToShield   — overheal converts to a shield
##   Combination: TeamShield (with Sage)
##
## setup() no longer instantiates anything — ability scripts are static.
## It sets each ability's tunable values as metadata directly on `player`,
## then points the ability slots at the CLASS itself (no .new()).
class_name Aria_Abilities
extends AbilityHandler

enum Names { BARRIER_SHIELD, HEAL_ON_COIN, EXCESS_HEAL_TO_SHIELD, TEAM_SHIELD }

func setup() -> void:
	player.set_meta("BarrierShield_shield_hp", 65.0)
	player.set_meta("BarrierShield_power_cost", 20.0)
	player.set_meta("BarrierShield_cooldown_duration", 10.0)

	player.set_meta("HealOnCoin_heal_amount", 3.0)

	player.set_meta("ExcessHealToShield_heal_amount", 35.0)
	player.set_meta("ExcessHealToShield_power_cost", 18.0)
	player.set_meta("ExcessHealToShield_cooldown_duration", 14.0)

	player.set_meta("TeamShield_team_shield_hp", 30.0)
	player.set_meta("TeamShield_power_cost", 30.0)
	player.set_meta("TeamShield_cooldown_duration", 25.0)

	main_ability        = BarrierShield_Ability
	passive_ability     = HealOnCoin_Ability
	race_trait_ability  = ExcessHealToShield_Ability
	combination_ability = TeamShield_Ability


func trigger_main_ability(context: Dictionary = {}) -> Dictionary:
	if player and player.upgrade_level >= 2:
		player.apply_buff("reflect_shield", 2.0, 0.20)
	return BarrierShield_Ability.trigger(player)


func trigger_combination(context: Dictionary = {}) -> Dictionary:
	var partner: String = context.get("paired_character", "")
	if partner == "Sage":
		return TeamShield_Ability.trigger(player)
	return {"success": false, "reason": "requires_Sage"}


func on_coin_collected(amount: int) -> void:
	HealOnCoin_Ability.trigger(player)


func on_land() -> void:
	if player and player.upgrade_level >= 1 and player.is_shielded:
		var refresh: float = 10.0 + player.upgrade_level * 5.0
		player.add_shield(player.shield_hp + refresh)
