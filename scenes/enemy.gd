extends Node2D

signal turn_finished
signal path_changed(path: PackedVector2Array)

@export var tile_map: TileMap

var _astar: AStarGrid2D = AStarGrid2D.new()
@onready var _switches = get_tree().get_nodes_in_group("switches")

var _animations = {
	Vector2.DOWN: "walk_down",
	Vector2.UP: "walk_up",
	Vector2.LEFT: "walk_left",
	Vector2.RIGHT: "walk_right",
}

func _ready():
	position = position.snapped(Vector2.ONE * Globals.TILE_SIZE)
	position += Vector2.ONE * Globals.TILE_SIZE / 2

	var tile_map_size = tile_map.get_used_rect()
	
	_astar.region = tile_map_size
	_astar.cell_size = Vector2i(Globals.TILE_SIZE, Globals.TILE_SIZE)
	_astar.offset = _astar.cell_size * 0.5
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astar.update()

	for i in range(_astar.region.position.x, _astar.region.end.x):
		for j in range(_astar.region.position.y, _astar.region.end.y):
			var pos = Vector2i(i, j)
			var tile_data = tile_map.get_cell_tile_data(0, pos)
			var navigable = tile_data.get_custom_data("navigable") if tile_data else false
			var has_rock = tile_map.get_cell_source_id(1, pos) >= 0
			if not navigable or has_rock:
				_astar.set_point_solid(pos)

	for switch in _switches:
		_astar.set_point_solid(tile_map.local_to_map(switch.position))

# TODO: route around player?
func move():
	var closest_switch = null
	var closest_switch_path: PackedVector2Array = PackedVector2Array()

	var start_cell = tile_map.local_to_map(position)

	for switch in _switches:
		if switch.switched_on:
			var target_cell = tile_map.local_to_map(switch.position)
			# Temporarily mark the switch's cell as reachable so we can route to it
			_astar.set_point_solid(target_cell, false)
			var path = _astar.get_point_path(start_cell, target_cell)
			_astar.set_point_solid(target_cell, true)
			if not path:
				if Globals.DEBUG:
					print(name, " cannot reach ", switch)
			elif not closest_switch_path or path.size() < closest_switch_path.size():
				if Globals.DEBUG:
					print(switch.name, " is the closest switch so far")
				assert(path.size() != 1, "Enemy can't be in the same cell as a switch")
				closest_switch = switch
				closest_switch_path = path
			else:
				if Globals.DEBUG:
					print(switch.name, " is not the closest switch")

	var direction = Vector2(0, 0)
	if closest_switch:
		if Globals.DEBUG:
			print(name, " moving towards ", closest_switch.name)
		direction = (closest_switch_path[1] - closest_switch_path[0]).normalized()
		path_changed.emit(closest_switch_path.slice(1))
	else:
		# Choose from UP, DOWN, LEFT, RIGHT and ZERO with equal probability
		var x = randi() % 5 - 2
		direction = Vector2(signi(x % 2), x / 2)
		if Globals.DEBUG:
			print(name, " moving randomly ", direction)
		path_changed.emit(PackedVector2Array())

	if not direction:
		$AnimatedSprite2D.play("walk_down")
		turn_finished.emit()
	elif $GridMovement.move(direction):
		$AnimatedSprite2D.play(_animations[direction])
