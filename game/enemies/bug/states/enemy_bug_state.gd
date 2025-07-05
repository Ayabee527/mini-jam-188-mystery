class_name EnemyBugState
extends State

var enemy: EnemyBug

func _ready() -> void:
	await owner.ready
	enemy = owner as EnemyBug
	assert(enemy != null)
