## HealOverTime_Ability.gd
##
## STUB — pending the heal-over-time design conversation.
## Returns a clear failure instead of silently faking a tick system.
class_name HealOverTime_Ability
extends Object

const ABILITY_NAME := "HealOverTime"

static func trigger(player: Node2D) -> Dictionary:
	return {"success": false, "reason": "pending_hot_design_with_godeye"}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	return "(pending design) Heal over time."
