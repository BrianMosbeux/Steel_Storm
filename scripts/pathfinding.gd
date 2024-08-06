extends Node2D
class_name PathFinding

var tile_map: TileMap
var astar_grid = AStarGrid2D.new()


func create_astar_grid_2d(tile_map: TileMap):
	self.tile_map = tile_map
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = tile_map.tile_set.tile_size
	astar_grid.update()
	
	#var region_size = astar_grid.region.size
	#for x in region_size.x:
		#for y in region_size.y:
			#print(astar_grid.get_point_position(Vector2i(x,y)))


func get_new_path(start_pos: Vector2, end_pos: Vector2):
	var start_tile = tile_map.local_to_map(start_pos)
	var end_tile = tile_map.local_to_map(end_pos)
	var path_to_take = astar_grid.get_point_path(
		start_tile,
		end_tile
	)
	if path_to_take.is_empty():
		print("no path found")
	return path_to_take
