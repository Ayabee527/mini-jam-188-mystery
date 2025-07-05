class_name Room
extends Node2D

enum RoomType {
	START,
	COMBAT,
	LOG,
	EXIT,
	BOSS
}

@export var cam_holder: Marker2D
@export var doors: Array[RoomDoor]
@export var l_door: RoomDoor
@export var r_door: RoomDoor
@export var u_door: RoomDoor
@export var d_door: RoomDoor

var connections: Array[Vector2i] = []
var type: RoomType = RoomType.COMBAT

func _ready() -> void:
	initialize()

func initialize() -> void:
	open_doors()

func close_all_doors() -> void:
	for door: RoomDoor in doors:
		door.open = false

func open_doors() -> void:
	if connections.has(Vector2i.LEFT):
		l_door.open = true
	if connections.has(Vector2i.RIGHT):
		r_door.open = true
	if connections.has(Vector2i.UP):
		u_door.open = true
	if connections.has(Vector2i.DOWN):
		d_door.open = true

func _on_trigger_body_entered(body: Node2D) -> void:
	MainCam.target = cam_holder
	
	if type == RoomType.COMBAT:
		await get_tree().create_timer(0.2, false).timeout
		MainCam.shake(14, 8, 7)
		close_all_doors()
