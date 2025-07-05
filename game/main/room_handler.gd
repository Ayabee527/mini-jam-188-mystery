class_name RoomHandler
extends Node2D

const ROOM = preload("res://room/room.tscn")

class RoomNode:
	enum TYPE {
		START,
		COMBAT,
		LOG,
		EXIT,
		BOSS
	}
	
	var pos: Vector2i
	var connections: Array[Vector2i]
	var type: TYPE = TYPE.COMBAT
	
	func _init(in_pos: Vector2i) -> void:
		pos = in_pos
	
	func connect_room(dir: Vector2i) -> void:
		connections.append(dir)

@export var grid_size: Vector2i = Vector2i.ONE * 4
@export var min_main_path_length: int = 5
@export var max_main_path_length: int = 9
@export var min_branch_length: int = 2
@export var max_branch_length: int = 4

@export var player: Player

func _ready() -> void:
	var grid: Array[RoomNode] = generate_grid()
	grid_to_room(grid)

func generate_grid() -> Array[RoomNode]:
	var grid: Array[RoomNode] = []
	
	print_rich("[b][color='yellow']Generating main path[wave]...")
	var start_pos = Vector2i(
		randi_range(0, grid_size.x - 1),
		randi_range(0, grid_size.y - 1),
	)
	grid.append(
		RoomNode.new(start_pos)
	)
	
	var main_path: Array[RoomNode] = generate_walk(
		grid[0], min_main_path_length, max_main_path_length, grid
	)
	
	main_path.front().type = RoomNode.TYPE.START
	main_path.back().type = RoomNode.TYPE.EXIT
	
	for i: int in main_path.size():
		print(main_path[i].pos)
	
	print_rich("[color='red'][b]Main path done!")
	print("\n")
	
	print_rich("[b][color='cyan']Generating branches[wave]...")
	var branch_count: int = 0
	var branch_potentials: Array[RoomNode] = []
	for i: int in main_path.size():
		if i == main_path.size() - 1:
			continue
		
		branch_potentials.append(main_path[i])
	
	branch_potentials.shuffle()
	var branch_rooms: Array[RoomNode]
	for room: RoomNode in branch_potentials:
		if randf() <= 1 - pow(0.9, branch_count):
			continue
		
		if has_free_neighbors(room.pos, grid):
			print_rich("[b][color='blue']Branch ", branch_count + 1, ":")
			var branch = generate_walk(
				room, min_branch_length, max_branch_length, grid
			)
			
			for i: int in branch.size():
				print(branch[i].pos)
			
			branch_rooms.append_array(branch)
			branch_count += 1
	
	var log_room: RoomNode = branch_rooms.pick_random()
	log_room.type = RoomNode.TYPE.LOG
	
	print_rich("[color='red'][b]Branches done!")
	print("\n")
	
	return grid

func grid_to_room(grid: Array[RoomNode]) -> void:
	for room_node: RoomNode in grid:
		var room: Room = ROOM.instantiate()
		room.global_position = room_node.pos * 256.0
		room.type = room_node.type as int
		room.connections = room_node.connections
		add_child(room)
	
	player.global_position = (grid[0].pos * 256.0) + (Vector2.ONE * 128.0)
	#MainCam.global_position = player.global_position

func get_room(pos: Vector2i, rooms: Array[RoomNode]) -> RoomNode:
	for room: RoomNode in rooms:
		if room.pos == pos:
			return room
	
	return null

func has_free_neighbors(pos: Vector2i, rooms: Array[RoomNode]) -> bool:
	var dirs = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
	var new_pos: Vector2i = pos + dirs.pop_back()
	while not is_empty_spot(new_pos, rooms) or is_out_of_bounds(new_pos):
		if dirs.is_empty():
			return false
		else:
			new_pos = pos + dirs.pop_back()
	
	return true

func get_free_neighbors(pos: Vector2i, rooms: Array[RoomNode]) -> Array[Vector2i]:
	var frees: Array[Vector2i] = []
	
	var dirs = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
	while not dirs.is_empty():
		var new_pos: Vector2i = pos + dirs.pop_back()
		if is_empty_spot(new_pos, rooms) and not is_out_of_bounds(new_pos):
			frees.append(new_pos)
	
	return frees

func generate_walk(starting_room: RoomNode, min_length: int, max_length: int, rooms: Array[RoomNode]) -> Array[RoomNode]:
	var walk: Array[RoomNode] = []
	var latest: RoomNode
	
	var limit: int = randi_range(min_length, max_length)
	
	var cur_pos: Vector2i = starting_room.pos
	latest = starting_room
	walk.append(latest)
	
	var blocked: bool = false
	while not blocked and walk.size() < limit:
		var potentials: Array[Vector2i] = get_free_neighbors(cur_pos, rooms)
		if potentials.is_empty():
			blocked = true
			break
		
		var next_pos: Vector2i = potentials.pick_random()
		latest.connect_room(
			next_pos - latest.pos
		)
		
		var next = RoomNode.new(next_pos)
		next.connect_room(
			latest.pos - next_pos
		)
		walk.append(next)
		rooms.append(next)
		
		latest = next
		cur_pos = next_pos
	
	return walk

func is_empty_spot(pos: Vector2i, rooms: Array[RoomNode]) -> bool:
	if get_room(pos, rooms) == null:
		return true
	else:
		return false

func is_out_of_bounds(pos: Vector2i) -> bool:
	var bounds_rect: Rect2i = Rect2i(0, 0, grid_size.x, grid_size.y)
	if bounds_rect.has_point(pos):
		return false
	else:
		return true
