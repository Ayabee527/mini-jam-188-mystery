extends EnemyBugState

@export var turn_speed: float = 3.0
@export var ram_speed: float = 400.0
@export var stun_timer: Timer
@export var weapon: WeaponHandler

func physics_update(delta: float) -> void:
	if stun_timer.is_stopped():
		var new_transform := enemy.global_transform.looking_at(enemy.player.global_position)
		enemy.global_transform = enemy.global_transform.interpolate_with(
			new_transform, turn_speed * delta
		)
		
		enemy.apply_central_force(
			Vector2.from_angle(enemy.global_rotation) * ram_speed
		)


func _on_enemy_bug_body_entered(body: Node) -> void:
	weapon.shoot()
	stun_timer.start()
