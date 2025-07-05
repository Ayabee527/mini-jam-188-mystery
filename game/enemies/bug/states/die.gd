extends EnemyBugState

func enter(_msg:={}) -> void:
	enemy.queue_free()

func _on_health_has_died() -> void:
	if not is_active:
		state_machine.transition_to("Die")
