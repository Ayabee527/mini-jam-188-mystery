class_name RoomDoor
extends Area2D

@export var coll_shape: CollisionShape2D
@export var suck: GPUParticles2D
@export var line: Line2D

@export var open: bool = false:
	set = set_open

func set_open(new_open: bool) -> void:
	open = new_open
	if open:
		open_door()
	else:
		close_door()

func open_door() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(
		line, "scale:y", 1.0, 0.3
	)
	await tween.finished
	suck.emitting = true
	coll_shape.set_deferred("disabled", false)

func close_door() -> void:
	suck.emitting = false
	coll_shape.set_deferred("disabled", true)
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(
		line, "scale:y", 0.0, 0.3
	)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player = body as Player
		player.tp = global_position - (Vector2.from_angle(global_rotation) * 40.0)
