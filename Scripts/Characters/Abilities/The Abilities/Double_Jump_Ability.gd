extends Object

class_name Double_Jump_Ability

static var used_meta_name: String = "double_jump_used"

static func trigger(player: Node2D):
	if (player.is_on_floor()):
		player.set_meta(used_meta_name, false) # reset the moment they touch ground
		return

	if (player.has_meta(used_meta_name) && player.get_meta(used_meta_name) == true):
		return # already used the extra jump this time airborne

	player.set_meta(used_meta_name, true)
	player.velocity.y = player.jump_velocity
	player.current_state = Player.State.JUMP

static func update_points(player: Node2D, power_meter, max_points: float):
	pass
