extends Node2D


var player: Node2D
var click_validator: Button
var character: Node2D

# the characters on the team
var team: Array[Character_Data] # key by character name
var current_team_member: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_parent()
	click_validator = get_parent().get_node("Character Pressed")
	click_validator.gui_input.connect(input_handler)
	click_validator.modulate.a = 0.0 # make the button invisible
	character = player.get_node("Character")
	
	# TEMP
	team = []
	
	#team["TEST_1"] = Characters.get_info("TEST_1")
	#team["TEST_2"] = Characters.get_info("TEST_2")
	var name = Globals.enumAsString(Characters.Names.TEST_3, Characters.Names)
	team.append(Characters.get_info(name))
	
	name = Globals.enumAsString(Characters.Names.Land_Trotting_Creature, Characters.Names)
	team.append(Characters.get_info(name))
	
	name = Globals.enumAsString(Characters.Names.Airborne_Creature, Characters.Names)
	team.append(Characters.get_info(name))
	
	name = Globals.enumAsString(Characters.Names.Seafaring_Creature, Characters.Names)
	team.append(Characters.get_info(name))

# connecting it to gui_input maees it trigger whenever the mouse hovers over it. It needs to check if clicked
func input_handler(event: InputEvent) -> void:
	if (player.freeze_player):
		return
		
	if (player.get_node("Character").character_swap_blocked_by_ability):
		return
	
	if Input.is_action_just_pressed("select"):
		swap_character()

# if no specific character sent in -> toggle. Else, swap to it and adjust the current_team_member variable value
func swap_character(specific_member = null):
	current_team_member += 1
	if (specific_member != null): # NOTE: assumes that this is called using already known to be within 
		current_team_member = specific_member
	
	#var next_character = team.keys().find(character.data.name) + 1
	if (current_team_member >= team.size()):
		current_team_member = 0
	
	# change the character's data reference. NOTE: DO NOT send a deep copy. Make it shallow so that data can be updated here without needing to send back and forth
	character.data = team[current_team_member]
	character.update()
	
	player.modifiers.clear()
	
	# NOTE: These two tests below prove that a shallow copy is sent by updating a value on either end and printing the before and after from here
	#print(character.data.name)
	#character.test() # have it change the name on the Character.gd end
	#print(character.data.name)

	#print(character.data.name)
	#team[team.keys()[next_character]].name = "ffkjewfjke-9wjf-ewjfe"
	#print(character.data.name)
