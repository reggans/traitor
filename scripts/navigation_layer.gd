extends TileMapLayer

var _obstacles = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_get_obstacle_layers()

func _get_obstacle_layers():
	var layers = get_tree().get_nodes_in_group("Obstacles")
	
	for layer in layers:
		if layer is not TileMapLayer: continue
		_obstacles.append(layer)
	print(_obstacles)

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return _is_used_by_obstacle(coords)

func _is_used_by_obstacle(coords: Vector2i) -> bool:
	for layer in _obstacles:
		if coords in layer.get_used_cells():
			var is_obstacle = layer.get_cell_tile_data(coords).get_collision_polygons_count(0) > 0
			if is_obstacle:
				return true
	return false

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if not _is_used_by_obstacle(coords):
		tile_data.set_navigation_polygon(0, null)	
