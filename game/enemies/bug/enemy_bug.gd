class_name EnemyBug
extends RigidBody2D

@export var health: Health

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _on_hurtbox_hurt(hitbox: Hitbox, damage: int, invinc_time: float) -> void:
	health.hurt(damage)


func _on_hurtbox_knocked_back(knockback: Vector2) -> void:
	apply_central_impulse(knockback)
