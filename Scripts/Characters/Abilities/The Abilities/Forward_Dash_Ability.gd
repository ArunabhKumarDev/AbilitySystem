extends Object

class_name Forward_Dash_Ability

static var dash_active_meta_name: String = "forward_dash_active"

# NOTE: reuses Player.State.AIR_DASH even though this dash is ground-based.
# handle_input() only skips normal input processing for that specific state
# value (that's what Super_Jump's own air dash relies on too) — didn't want
# to add a new Player.State enum entry without confirming that's wanted
# first, so borrowing the existing one is the tradeoff for now.
static func trigger(player: Node2D):
	if (player.has_meta(dash_active_meta_name) && player.get_meta(dash_active_meta_name) == true):
		return

	player.set_meta(dash_active_meta_name, true)

	var direction = 1
	if (player.velocity.x < 0):
		direction = -1

	player.current_state = Player.State.AIR_DASH
	player.velocity.y = 0
	player.velocity.x = player.dash_speed * direction

	await player.get_tree().create_timer(player.dash_time).timeout

	player.current_state = Player.State.IDLE
	player.set_meta(dash_active_meta_name, false)

static func update_points(player: Node2D, power_meter, max_points: float):
	pass
