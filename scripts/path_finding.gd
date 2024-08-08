extends Node2D
class_name PathFinding


@export var enabled_color: Color = Color("0000ff55")
@export var disabled_color: Color = Color("c11f3658")
@export var should_display_grid: bool = false

var grid_rects := {}
var tile_map: TileMap
var astar_grid = AStarGrid2D.new()
var half_cell_size: Vector2


@onready var grid = $Grid


func _physics_process(delta):
	update_navigation_map()

func create_astar_grid_2d(tile_map: TileMap):
	self.tile_map = tile_map
	astar_grid.region = tile_map.get_used_rect()
	print(astar_grid.region)
	#print(astar_grid.region)
	astar_grid.cell_size = tile_map.tile_set.tile_size
	half_cell_size = astar_grid.cell_size / 2
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.update()
	var tiles = tile_map.get_used_cells(0)
	if should_display_grid:
		for tile in tiles:
			var rect = ColorRect.new()
			grid.add_child(rect)
			grid_rects[tile] = rect
			rect.modulate = Color(1, 1, 1, 0.5)
			rect.color = enabled_color
			rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
			rect.size = astar_grid.cell_size
			rect.position = tile_map.map_to_local(tile) - half_cell_size

func update_navigation_map():
	#create_astar_grid_2d(tile_map)
	var region_size = astar_grid.region.size
	for i in grid_rects:
		astar_grid.set_point_solid(i, false)
		if should_display_grid:
			grid_rects[i].color = enabled_color
	var obstacles = get_tree().get_nodes_in_group("obstacles")
	#print(obstacles)
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
			if should_display_grid:
				grid_rects[tile_coord].color = disabled_color
			#draw_rect(Rect2i(tile_map.map_to_local(tile_coord), astar_grid.cell_size), disabled_color, true)
			
	
	
				
	
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
