extends Node2D
class_name PathFinding

var tile_map: TileMap
var astar_grid = AStarGrid2D.new()
var half_cell_size: Vector2

func _physics_process(delta):
	update_navigation_map()


func create_astar_grid_2d(tile_map: TileMap):
	self.tile_map = tile_map
	astar_grid.region = tile_map.get_used_rect()
	#print(astar_grid.region)
	astar_grid.cell_size = tile_map.tile_set.tile_size
	half_cell_size = astar_grid.cell_size / 2
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.update()
	
	
			#print(astar_grid.get_point_position(Vector2i(x,y)))

func update_navigation_map():
	create_astar_grid_2d(tile_map)
	var region_size = astar_grid.region.size
	var obstacles = get_tree().get_nodes_in_group("obstacles")
	#for x in region_size.x:
		#for y in region_size.y:
			#var tile_position = Vector2i(x, y)
			#var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			#if tile_data == null or tile_data.get_custom_data("walkable") == false:
				#astar_grid.set_point_solid(tile_position)
	for obstacle in obstacles:
		if obstacle is CharacterBody2D:
			var tile_coord = tile_map.local_to_map(obstacle.collision_shape_2d.global_position)
			astar_grid.set_point_solid(tile_coord, true)
	
	
				
	
func get_new_path(start_pos: Vector2, end_pos: Vector2):
	var start_tile = tile_map.local_to_map(start_pos)
	var end_tile = tile_map.local_to_map(end_pos)
	var id_path = astar_grid.get_id_path(start_tile, end_tile)
	#print(id_path)
	
	var path_map = astar_grid.get_id_path(
		start_tile,
		end_tile
	)
	
	var path_world = []
	for point in path_map:
		var point_world = tile_map.map_to_local(point)
		path_world.append(point_world)
	
	if path_world.size() < 1:
		print("no path")
	return path_world
