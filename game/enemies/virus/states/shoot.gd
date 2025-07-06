extends EnemyVirusState

@export var turn_speed: float = 10.0
@export var weapon: WeaponHandler

func enter(_msg:={}) -> void:
	enemy.look_at(enemy.player.global_position)
	weapon.firing = true

func physics_update(delta: float) -> void:
	var new_transform := enemy.global_transform.looking_at(enemy.player.global_position)
	enemy.global_transform = enemy.global_transform.interpolate_with(
		new_transform, turn_speed * delta
	)

func exit() -> void:
	weapon.firing = false
