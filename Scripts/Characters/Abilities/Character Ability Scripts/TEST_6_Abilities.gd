extends Object

class_name TEST_6_Abilities

static func trigger(player: Node2D):
	var ability_to_trigger = Globals.enumAsString(player.get_node("Character").data.ability_info.keys()[0], Character_Abilities.Names)
	var ability = Globals.load_script(ability_to_trigger + "_Ability")
	ability.trigger(player)

static var max_points: float = 100

static func update_points(player: Node2D, power_meter) -> float:
	var ability_to_trigger = Globals.enumAsString(player.get_node("Character").data.ability_info.keys()[0], Character_Abilities.Names)
	var ability = Globals.load_script(ability_to_trigger + "_Ability")
	ability.update_points(player, power_meter, max_points)

	return (power_meter.current_points / max_points) * 100
