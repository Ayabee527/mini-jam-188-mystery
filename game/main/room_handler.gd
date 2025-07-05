class_name RoomHandler
extends Node2D

const ROOM = preload("res://room/room.tscn")

class RoomNode:
	var pos: Vector2i
	var connections: Array[Vector2i]
	
	func _init(in_pos: Vector2i) -> void:
		pos = in_pos
	
	func connect_room(dir: Vector2i) -> void:
		connections.append(dir)

@export var grid_size: Vector2i = Vector2i.ONE * 3
@export var max_main_path_length: int = 6

var grid: Array[RoomNode] = []

var cur_pos: Vector2i
var main_path_room_count: int = 0

func _ready() -> void:
	generate_grid()

func generate_grid() -> void:
	print_rich("[b][color='yellow']Generating main path[wave]...")
	cur_pos = Vector2(
		randi_range(0, grid_size.x - 1),
		randi_range(0, grid_size.y - 1),
	)
	print(cur_pos)
	grid.append(
		RoomNode.new(cur_pos)
	)
	main_path_room_count = 1
	
	var blocked: bool = false
	while not blocked and main_path_room_count < max_main_path_length:
		blocked = walk()
	
	print_rich("[color='red'][b]Main path done!")
	print("\n")
	
	print_rich("[b][color='yellow']Generating branches[wave]...")

func get_room(pos: Vector2i) -> RoomNode:
	for room: RoomNode in grid:
		if room.pos == pos:
			return room
	
	return null

func has_free_neighbors(pos: Vector2i) -> bool:
	var dirs = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
	var new_pos: Vector2i = cur_pos + dirs.pop_back()
	while not is_empty_spot(new_pos) or is_out_of_bounds(new_pos):
		if dirs.is_empty():
			return false
		else:
			new_pos = cur_pos + dirs.pop_back()
	
	
	return true

func walk() -> bool:
	var dirs = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
	dirs.shuffle()
	var new_pos: Vector2i = cur_pos + dirs.pop_back()
	while not is_empty_spot(new_pos) or is_out_of_bounds(new_pos):
		if dirs.is_empty():
			new_pos = cur_pos
			break
		else:
			new_pos = cur_pos + dirs.pop_back()
	
	if new_pos == cur_pos:
		return true
	
	var last: RoomNode = grid.back() as RoomNode
	last.connect_room(new_pos - cur_pos)
	
	grid.append(
		RoomNode.new(new_pos)
	)
	var new: RoomNode = grid.back() as RoomNode
	new.connect_room(cur_pos - new_pos)
	
	cur_pos = new_pos
	main_path_room_count += 1
	
	print(new_pos)
	return false

func is_empty_spot(pos: Vector2i) -> bool:
	if get_room(pos) == null:
		return true
	else:
		return false

func is_out_of_bounds(pos: Vector2i) -> bool:
	var bounds_rect: Rect2i = Rect2i(0, 0, grid_size.x, grid_size.y)
	if bounds_rect.has_point(pos):
		return false
	else:
		return true
