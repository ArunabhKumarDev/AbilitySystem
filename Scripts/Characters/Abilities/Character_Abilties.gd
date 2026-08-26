extends Object

class_name Character_Abilities

enum Names {
	Super_Jump,
	Rythmic_Rupture,
	Booming_Bongo, # complete a rythmic sequence that causes the opponent being tracked to stumble if on the ground
	Hydro_Rythmn, # the player is made to complete a rythmic squence and success charges the power meter
	Speed_Burst, # temporary movement speed increase, applied via the modifier system
	Forward_Dash, # ground dash, same underlying pattern as Super_Jump's air dash
	Double_Jump, # one extra jump per airborne period
	Bonus_Perfect_Jump, # awards points while airborne, via the real scoring path
}

enum Types {
	Active,
	Passive,
	Hostile,
	Friendly
}
