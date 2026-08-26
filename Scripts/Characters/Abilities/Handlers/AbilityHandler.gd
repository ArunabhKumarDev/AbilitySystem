## AbilityHandler.gd
## Base class for every character's ability handler.
##
## Ability scripts are now static (per architecture review) — no .new(), no instance
## state. main_ability / passive_ability / etc. hold a reference to the
## ABILITY CLASS itself (e.g. `main_ability = BarrierShield_Ability`, no
## parentheses), and calling `main_ability.trigger(player)` invokes the
## static function through that class reference — this is valid GDScript,
## not a workaround.
##
## _sync_upgrade() is gone entirely: there's no per-ability instance field
## to sync into anymore. Abilities read player.upgrade_level (or
## player.get_meta("upgrade_level", 0)) directly, whenever they need it.
##
## FLOW:
##   CharacterBase.trigger_ability(context)
##     → ability_handler.trigger_main_ability(context)   ← context stays here
##     → main_ability.trigger(player)                     ← static call, player only
class_name AbilityHandler
extends RefCounted

var player: Node2D = null

# Class references (not instances) — e.g. BarrierShield_Ability, no .new()
var main_ability:        Object = null
var passive_ability:     Object = null
var race_trait_ability:  Object = null
var combination_ability: Object = null

func setup() -> void:
	push_error("[AbilityHandler] setup() not overridden by: " + get_script().resource_path)


func trigger_main_ability(context: Dictionary = {}) -> Dictionary:
	if main_ability == null:
		return {"success": false, "reason": "no_main_ability"}
	return main_ability.trigger(player)


func trigger_passive(context: Dictionary = {}) -> Dictionary:
	if passive_ability == null:
		return {"success": false, "reason": "no_passive_ability"}
	return passive_ability.trigger(player)


func trigger_race_trait(context: Dictionary = {}) -> Dictionary:
	if race_trait_ability == null:
		return {"success": false, "reason": "no_race_trait"}
	return race_trait_ability.trigger(player)


func trigger_combination(context: Dictionary = {}) -> Dictionary:
	if combination_ability == null:
		return {"success": false, "reason": "no_combination_ability"}
	return combination_ability.trigger(player)


## Called by CharacterBase when a coin is collected.
func on_coin_collected(_amount: int) -> void:
	pass

## Called by CharacterBase when the character lands after being airborne.
func on_land() -> void:
	pass


## Runs update_points() on every equipped ability that has the method.
func update_all_points() -> void:
	for ability in [main_ability, passive_ability, race_trait_ability, combination_ability]:
		if ability != null and ability.has_method("update_points"):
			ability.update_points(player)


func get_ability_descriptions() -> Dictionary:
	return {
		"main":        main_ability.get_description(player)        if main_ability        and main_ability.has_method("get_description")        else "—",
		"passive":     passive_ability.get_description(player)     if passive_ability     and passive_ability.has_method("get_description")     else "—",
		"race_trait":  race_trait_ability.get_description(player)  if race_trait_ability  and race_trait_ability.has_method("get_description")  else "—",
		"combination": combination_ability.get_description(player) if combination_ability and combination_ability.has_method("get_description") else "—",
	}
