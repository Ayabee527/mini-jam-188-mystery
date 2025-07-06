class_name RoomEnemyHandler
extends Node2D

signal enemy_killed(enemy: Node2D)
signal wave_cleared()

const SPAWN = preload("res://room/spawn.tscn")

const BUG = preload("res://enemies/bug/enemy_bug.tscn")
const VIRUS = preload("res://enemies/virus/enemy_virus.tscn")

const ENEMIES = {
	"BUG": BUG,
	"VIRUS": VIRUS
}

const COSTS = {
	"BUG": 2,
	"VIRUS": 3
}

@export var extra_spend: int = 2

var spawned_enemies: Array[Node2D] = []

func _ready() -> void:
	pass

func spawn_wave(difficulty: int) -> void:
	var score: int = difficulty + extra_spend
	
	var chosens: Array = []
	
	var enemies: Array = COSTS.keys().duplicate()
	var score_out: bool = false
	while score > 0:
		enemies = COSTS.keys().duplicate()
		
		enemies.shuffle()
		var chosen_enemy = enemies.pop_back()
		
		while (COSTS[chosen_enemy] > score):
			if enemies.size() == 0:
				score_out = true
				break
			
			chosen_enemy = enemies.pop_back()
		
		if score_out:
			break
		
		score -= COSTS[chosen_enemy]
		
		chosens.append(chosen_enemy)
	
	for name: String in chosens:
		var enemy: Node2D = ENEMIES[name].instantiate()
		spawned_enemies.append(enemy)
		enemy.position = Vector2(
			randf_range(-96, 96),
			randf_range(-96, 96),
		)
		if enemy.has_signal("died"):
			enemy.smashed.connect(kill_enemy.bind(enemy))
		else:
			enemy.tree_exiting.connect(kill_enemy.bind(enemy))
		
		var spawn = SPAWN.instantiate()
		spawn.position = enemy.position
		
		add_child(spawn)
		await get_tree().create_timer(0.2, false).timeout
		add_child(enemy)
		await get_tree().create_timer(0.1, false).timeout

func kill_enemy(enemy: Node2D) -> void:
	spawned_enemies.erase(enemy)
	enemy_killed.emit(enemy)
	if spawned_enemies.size() <= 0:
		wave_cleared.emit()
