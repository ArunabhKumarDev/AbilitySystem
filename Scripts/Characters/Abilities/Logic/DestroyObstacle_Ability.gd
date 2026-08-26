## DestroyObstacle_Ability.gd
## Passive — arms a buff that destroys obstacles on contact.
class_name DestroyObstacle_Ability
extends Object

const ABILITY_NAME := "DestroyObstacle"

static func trigger(player: Node2D) -> Dictionary:
	var duration: float = player.get_meta("DestroyObstacle_duration", 3.5)
	var dur: float = duration + player.upgrade_level * 0.5
	player.apply_buff("destroy_on_contact", dur)
	return {"success": true, "buff_duration": dur}

static func update_points(player: Node2D) -> void:
	pass

static func get_description(player: Node2D) -> String:
	var duration: float = player.get_meta("DestroyObstacle_duration", 3.5)
	return "Destroy obstacles on contact for %.0f seconds." % duration
