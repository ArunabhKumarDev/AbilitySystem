## AbilityList.gd
## The single script under Abilities/ (alongside Handlers/ and Logic/).
## Holds the name of every ability in the system, plus a rough category
## for each — per the original spec.
##
## NOTE FOR GODEYE: I wasn't 100% sure if "Character_Abilities.gd" in your
## workflow notes meant this central file, or a Names enum scoped to each
## individual {Character}_Abilities.gd handler instead. I went with ONE
## global enum here since the original brief said "the script holds the
## name of every ability" (singular). Easy to split per-handler if that's
## what you actually meant.
##
## Enum entries are PascalCase (matching the ability's own name, e.g.
## BarrierShield) rather than ALL_CAPS, so script_path() below can derive
## the file name directly via Names.keys() — no separate lookup table
## needed, and it stays "named exactly like it is in the enumerator."
class_name AbilityList
extends RefCounted

enum Names {
	BarrierShield,
	TeamShield,
	HealOnCoin,
	ExcessHealToShield,
	SpeedBurst,
	SpeedAfterHazard,
	ForwardDash,
	CoinCyclone,
	MissedCoinCollect,
	DoubleCoinValue,
	HealOverTime,
	HealAllTeammates,
	ReduceTeammateCd,
	ShieldAllTeammates,
	HealTeam,
	TimedInvincibility,
	DestroyObstacle,
	NextHitBlock,
	DoubleJump,
	BonusPerfectJump,
	Hover,
	AirDash,
	BlazeLyraComboSpeed,
	RexBlazeComboSpeed,
}

enum Type {
	SHIELD, HEALING, MAGNET, SPEED, JUMP_AND_AIR,
	INVINCIBILITY, TEAM_SUPPORT, HAZARD_CONTROL, BONUS_POINTS, DASH
}

const TYPES: Dictionary = {
	Names.BarrierShield:        Type.SHIELD,
	Names.TeamShield:           Type.SHIELD,
	Names.HealOnCoin:           Type.HEALING,
	Names.ExcessHealToShield:   Type.HEALING,
	Names.SpeedBurst:           Type.SPEED,
	Names.SpeedAfterHazard:     Type.SPEED,
	Names.ForwardDash:          Type.DASH,
	Names.CoinCyclone:          Type.MAGNET,
	Names.MissedCoinCollect:    Type.MAGNET,
	Names.DoubleCoinValue:      Type.BONUS_POINTS,
	Names.HealOverTime:         Type.HEALING,
	Names.HealAllTeammates:     Type.TEAM_SUPPORT,
	Names.ReduceTeammateCd:     Type.TEAM_SUPPORT,
	Names.ShieldAllTeammates:   Type.TEAM_SUPPORT,
	Names.HealTeam:             Type.HEALING,
	Names.TimedInvincibility:   Type.INVINCIBILITY,
	Names.DestroyObstacle:      Type.HAZARD_CONTROL,
	Names.NextHitBlock:         Type.INVINCIBILITY,
	Names.DoubleJump:           Type.JUMP_AND_AIR,
	Names.BonusPerfectJump:     Type.BONUS_POINTS,
	Names.Hover:                Type.JUMP_AND_AIR,
	Names.AirDash:              Type.JUMP_AND_AIR,
	Names.BlazeLyraComboSpeed:  Type.SPEED,
	Names.RexBlazeComboSpeed:   Type.SPEED,
}

## Path to a Names entry's script, derived from the enum key string itself —
## e.g. Names.BarrierShield -> "BarrierShield" -> BarrierShield_Ability.gd
static func script_path(n: Names) -> String:
	return "res://Scripts/Characters/Abilities/Logic/%s_Ability.gd" % Names.keys()[n]

## Returns the ability's CLASS reference (not an instance — ability
## scripts are static now, no .new() anywhere). Handlers normally just
## reference the class directly by name (e.g. `main_ability =
## BarrierShield_Ability`); this is here for anywhere you want to resolve
## a class dynamically by enum/name instead (debug menus, data-driven
## loadouts, etc). Call .trigger(player) on the result the same way.
static func load_ability(n: Names) -> Object:
	return load(script_path(n))

static func get_type(n: Names):
	return TYPES.get(n, null)
