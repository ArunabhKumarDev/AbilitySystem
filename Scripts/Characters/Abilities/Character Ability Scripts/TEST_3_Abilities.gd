extends Object

class_name TEST_3_Abilities

static func trigger(player: Node2D):
	# same generic pattern as TEST_1_Abilities.gd: grab this character's
	# first (only) assigned ability, load its script, and trigger it
	var ability_to_trigger = Globals.enumAsString(player.get_node("Character").data.ability_info.keys()[0], Character_Abilities.Names)
	var ability = Globals.load_script(ability_to_trigger + "_Ability")
	ability.trigger(player)

# this script will hold the max points of the power meter
# this is for the power meter
static var max_points: float = 100 # set the max points here

# this function will call the update_points() function in the ability's script
# this allows things to be more modular
static func update_points(player: Node2D, power_meter) -> float:
	var ability_to_trigger = Globals.enumAsString(player.get_node("Character").data.ability_info.keys()[0], Character_Abilities.Names)
	var ability = Globals.load_script(ability_to_trigger + "_Ability")
	ability.update_points(player, power_meter, max_points)

	# calculate the percentage filled in
	return (power_meter.current_points / max_points) * 100
