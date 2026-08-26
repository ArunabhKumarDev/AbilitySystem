extends Object

class_name Bonus_Perfect_Jump_Ability

static var Points_Awarded: float = 10

# uses the real, already-confirmed scoring path (the same one Coin_Behavior.gd
# uses when a coin is collected) rather than anything invented
static func trigger(player: Node2D):
	if (player.is_on_floor()):
		return # only rewards while actually airborne

	Player.update_points(Points_Awarded, player)

static func update_points(player: Node2D, power_meter, max_points: float):
	pass
