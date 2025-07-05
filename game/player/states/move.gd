extends PlayerState

@export var move_speed: float = 400.0

func physics_update(_delta: float) -> void:
	var move_dir := player.get_move_vector()
	
	player.apply_central_force(
		move_dir * move_speed
	)
	
	if not move_dir:
		state_machine.transition_to("Idle")
