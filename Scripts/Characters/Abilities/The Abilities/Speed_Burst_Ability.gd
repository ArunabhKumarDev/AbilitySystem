extends Object

class_name Speed_Burst_Ability

# how much the player's base speed is multiplied by while the burst is active
static var Speed_Multiplier: float = 1.6

# how many physics frames the burst lasts (~1 second at the project's 60fps default)
static var Burst_Duration_Frames: int = 60

static var burst_active_meta_name: String = "speed_burst_active"

# applies the speed boost for one physics frame. Passed into add_modifier()
# below, which the base Player_Movement script calls every physics frame
# via apply_modifiers() — re-adding it each frame is what makes it apply
# for the whole burst duration instead of just one frame.
static func _apply_speed_boost(player: Node2D) -> void:
	player.speed *= Speed_Multiplier

static func trigger(player: Node2D):
	# ignore repeat presses while a burst is already underway
	if (player.has_meta(burst_active_meta_name) && player.get_meta(burst_active_meta_name) == true):
		return

	player.set_meta(burst_active_meta_name, true)

	for i in range(Burst_Duration_Frames):
		player.add_modifier("speed_burst", _apply_speed_boost, false)
		await player.get_tree().physics_frame

	player.set_meta(burst_active_meta_name, false)

# no power meter gating for this first pass — matches how Booming_Bongo_Ability
# and Hydro_Rythmn_Ability also leave this as a no-op for now
static func update_points(player: Node2D, power_meter, max_points: float):
	pass
