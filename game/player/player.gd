class_name Player
extends RigidBody2D

var tp: Vector2 = Vector2.INF

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if tp != Vector2.INF:
		var new_transform := state.transform
		new_transform.origin = tp
		state.transform = new_transform
		
		tp = Vector2.INF

func get_move_vector() -> Vector2:
	return Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down"
	)
