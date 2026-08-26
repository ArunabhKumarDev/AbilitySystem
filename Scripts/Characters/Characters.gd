extends Object

class_name Characters

enum Names {
	TEST_1,
	TEST_2,
	TEST_3,
	Land_Trotting_Creature,
	Airborne_Creature,
	Seafaring_Creature
}

# this andthe below table are for terrain relations
enum Terrain_Relations {
	Affinity,
	Neutral,
	Struggle
}

# format: { character_name: { tile_name: terrain_relation } }
static var table: Dictionary = { # only put the tiles that need a custom value here
	Names.TEST_1: 
	{ 
		#Tiles.Names.TEST_1: Terrain_Relations.Neutral, 
		#Tiles.Names.TEST_2: Terrain_Relations.Struggle, 
		#Tiles.Names.Air: Terrain_Relations.Neutral,
		#Tiles.Names.Water: Terrain_Relations.Neutral,
		#Tiles.Names.Bordered_Square: Terrain_Relations.Neutral, 
		#Tiles.Names.Stage_Steel: Terrain_Relations.Neutral, 
		#Tiles.Names.Stage_Steel_Complex: Terrain_Relations.Neutral 
	},
	Names.TEST_2: 
	{ 
		#Tiles.Names.TEST_1: Terrain_Relations.Struggle, 
		#Tiles.Names.TEST_2: Terrain_Relations.Neutral, 
		#Tiles.Names.Air: Terrain_Relations.Neutral,
		#Tiles.Names.Water: Terrain_Relations.Neutral,
		#Tiles.Names.Bordered_Square: Terrain_Relations.Neutral, 
		#Tiles.Names.Stage_Steel: Terrain_Relations.Neutral, 
		#Tiles.Names.Stage_Steel_Complex: Terrain_Relations.Neutral
	},
	Names.TEST_3:
	{
		#Tiles.Names.TEST_1: Terrain_Relations.Neutral,
		#Tiles.Names.TEST_2: Terrain_Relations.Neutral,
		#Tiles.Names.Air: Terrain_Relations.Neutral,
		#Tiles.Names.Water: Terrain_Relations.Neutral,
		#Tiles.Names.Bordered_Square: Terrain_Relations.Neutral,
		#Tiles.Names.Stage_Steel: Terrain_Relations.Neutral,
		#Tiles.Names.Stage_Steel_Complex: Terrain_Relations.Neutral
	},
	Names.Land_Trotting_Creature: { 
		#Tiles.Names.TEST_1: Terrain_Relations.Neutral, 
		#Tiles.Names.TEST_2: Terrain_Relations.Neutral, 
		#Tiles.Names.Air: Terrain_Relations.Neutral,
		#Tiles.Names.Water: Terrain_Relations.Neutral,
		#Tiles.Names.Bordered_Square: Terrain_Relations.Neutral, 
		#Tiles.Names.Stage_Steel: Terrain_Relations.Neutral, 
		#Tiles.Names.Stage_Steel_Complex: Terrain_Relations.Neutral
	},
	Names.Airborne_Creature: { 
		#Tiles.Names.TEST_1: Terrain_Relations.Neutral, 
		#Tiles.Names.TEST_2: Terrain_Relations.Neutral, 
		#Tiles.Names.Air: Terrain_Relations.Neutral,
		#Tiles.Names.Water: Terrain_Relations.Struggle,
		#Tiles.Names.Bordered_Square: Terrain_Relations.Neutral, 
		#Tiles.Names.Stage_Steel: Terrain_Relations.Neutral, 
		#Tiles.Names.Stage_Steel_Complex: Terrain_Relations.Neutral
	},
	Names.Seafaring_Creature: {
		#Tiles.Names.TEST_1: Terrain_Relations.Struggle, 
		#Tiles.Names.TEST_2: Terrain_Relations.Struggle, 
		#Tiles.Names.Air: Terrain_Relations.Neutral,
		#Tiles.Names.Water: Terrain_Relations.Affinity,
		#Tiles.Names.Bordered_Square: Terrain_Relations.Struggle, 
		#Tiles.Names.Stage_Steel: Terrain_Relations.Struggle, 
		#Tiles.Names.Stage_Steel_Complex: Terrain_Relations.Struggle
	}
}

static func get_terrain_relation(character_name: String, movement_style: Player.Movement_Style, terrain_name: String, convert_to_string: bool = false):
	var name_as_enum_int = Globals.stringAsEnumInt(character_name, Characters.Names)
	var terrain_name_as_enum_int = Globals.stringAsEnumInt(terrain_name, Tiles.Names)
	
	#print("===============")
	#print(character_name, " ", terrain_name)
	#print(name_as_enum_int == null, " ", terrain_name_as_enum_int == null)
	
	# if either value does not have an enum value, return neutral relation
	if (name_as_enum_int == null || terrain_name_as_enum_int == null):
		if (convert_to_string):
			return Globals.enumAsString(Terrain_Relations.Neutral, Terrain_Relations)
		else:
			return Terrain_Relations.Neutral
	
	if (table.keys().has(name_as_enum_int) == false || table[name_as_enum_int] == null || table[name_as_enum_int].has(terrain_name_as_enum_int) == false):
		if (convert_to_string):
			return Globals.enumAsString(Terrain_Relations.Neutral, Terrain_Relations)
		else:
			return Terrain_Relations.Neutral
	
	#print(table[name_as_enum_int] == null, " ", table[name_as_enum_int][terrain_name_as_enum_int] == null)
	
	# if the entry does not exist, return neutral
	var return_value = table[name_as_enum_int][terrain_name_as_enum_int]
	if (return_value == null):
		return_value = Terrain_Relations.Neutral
	
	# if want to convert to string, convert to string value before sending back
	if (convert_to_string):
		return Globals.enumAsString(return_value, Terrain_Relations)
	else:
		return return_value
	
# uses the int value of the tile name enum values to key the function that will give that data
static var data_name_map: Dictionary = { 
	Names.TEST_1: TEST_1, 
	Names.TEST_2: TEST_2, 
	Names.TEST_3: TEST_3,
	Names.Land_Trotting_Creature: Land_Trotting_Creature,
	Names.Airborne_Creature: Airborne_Creature,
	Names.Seafaring_Creature: Seafaring_Creature
}
	
# by default it returns null
static func get_info(character_name: String):
	if (Names.keys().has(character_name)): # if the tile name is valid
		return data_name_map[Names.keys().find(character_name)].call() # grab its index in the dictionary that maps the name as the enum int value to the corresponding function and use that to get the function and call it
	
	return null

static func TEST_1() -> Character_Data:
	return Character_Data.new(Globals.enumAsString(Names.TEST_1, Names), Player.Movement_Style.Land_Trotter, { Character_Abilities.Names.Super_Jump: [Character_Abilities.Types.Active, Character_Abilities.Types.Friendly] }, Globals.Terrain_Types.Ground) 
	
static func TEST_2() -> Character_Data:
	return Character_Data.new(Globals.enumAsString(Names.TEST_2, Names), Player.Movement_Style.Land_Trotter, { Character_Abilities.Names.Rythmic_Rupture: [Character_Abilities.Types.Hostile, Character_Abilities.Types.Active] }, Globals.Terrain_Types.Ground)

static func TEST_3() -> Character_Data:
	return Character_Data.new(Globals.enumAsString(Names.TEST_3, Names), Player.Movement_Style.Land_Trotter, { Character_Abilities.Names.Speed_Burst: [Character_Abilities.Types.Active, Character_Abilities.Types.Friendly] }, Globals.Terrain_Types.Ground)

static func Land_Trotting_Creature() -> Character_Data:
	return Character_Data.new(Globals.enumAsString(Names.Land_Trotting_Creature, Names), Player.Movement_Style.Land_Trotter, { Character_Abilities.Names.Super_Jump: [Character_Abilities.Types.Active, Character_Abilities.Types.Friendly] }, Globals.Terrain_Types.Ground) 
	
static func Airborne_Creature() -> Character_Data:
	return Character_Data.new(Globals.enumAsString(Names.Airborne_Creature, Names), Player.Movement_Style.Airborne, { Character_Abilities.Names.Booming_Bongo: [Character_Abilities.Types.Hostile, Character_Abilities.Types.Active] }, Globals.Terrain_Types.Sky)
	
static func Seafaring_Creature() -> Character_Data:
	return Character_Data.new(Globals.enumAsString(Names.Seafaring_Creature, Names), Player.Movement_Style.Seafaring, { Character_Abilities.Names.Hydro_Rythmn: [Character_Abilities.Types.Friendly, Character_Abilities.Types.Active] }, Globals.Terrain_Types.Water)
