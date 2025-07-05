class_name Player
extends RigidBody2D

@export var weapon: WeaponHandler

var tp: Vector2 = Vector2.INF

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if tp != Vector2.INF:
		var new_transform := state.transform
		new_transform.origin = tp
		state.transform = new_transform
		
		tp = Vector2.INF

func _physics_process(delta: float) -> void:
	weapon.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):
		weapon.firing = true
	if Input.is_action_just_released("shoot"):
		weapon.firing = false

func get_move_vector() -> Vector2:
	return Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down"
	)


func _on_hurtbox_hurt(hitbox: Hitbox, damage: int, invinc_time: float) -> void:
	pass # Replace with function body.


func _on_hurtbox_knocked_back(knockback: Vector2) -> void:
	apply_central_impulse(knockback)
