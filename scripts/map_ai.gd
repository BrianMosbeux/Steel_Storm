extends Node2D


enum BaseCaptureStartOrder {
	FIRST,
	LAST
}


@export var Player: PackedScene
@export var base_capture_start_order: BaseCaptureStartOrder
@export var team_name: Team.TeamName
@export var Unit: PackedScene
@export var max_units_alive: int = 4

var target_base: CapturableBase = null 
var capturable_bases: Array = []
var respawn_points: Array = []
var next_spawn_to_use: int = 0
var player_instance: CharacterBody2D

@onready var team = $Team
@onready var unit_container = $UnitContainer
@onready var respawn_timer = $RespawnTimer
@onready var camera_2d = $"../Camera2D"


func initialize(capturable_bases: Array, respawn_points: Array):
	team.team = team_name
	self.respawn_points = respawn_points
	for point in respawn_points:
		spawn_unit(point)
	self.capturable_bases = capturable_bases
	for base in capturable_bases:
		base.connect("base_captured", self.handle_base_captured)
	check_for_next_capturable_base()


func handle_base_captured(_new_team: int):
	check_for_next_capturable_base()
	
	
func check_for_next_capturable_base():
	var next_base = get_next_capturable_base()
	if next_base:
		target_base = next_base
		assign_next_capturable_base_to_units(next_base)

func get_next_capturable_base():
	var list_of_bases: Array
	if base_capture_start_order == BaseCaptureStartOrder.FIRST:
		list_of_bases = range(capturable_bases.size())
	else:
		list_of_bases = range(capturable_bases.size() - 1, -1, -1)
	for i in list_of_bases:
		var base: CapturableBase = capturable_bases[i]
		if team.team != base.team.team:
			return base
	return null

func assign_next_capturable_base_to_units(base: CapturableBase):
	#if base_location == null and base_location == Vector2.ZERO:
		#return
	for unit in unit_container.get_children():
		if unit != Player:
			set_unit_ai_to_advance_to_next_base(unit)
		
func set_unit_ai_to_advance_to_next_base(unit):
	if target_base:
		var ai = unit.ai
		ai.next_base = target_base.global_position
		ai.current_state = AI.State.ADVANCE
	
func spawn_unit(respawn_point: Marker2D):
	if Player and player_instance == null:
		player_instance = Player.instantiate()
		player_instance.global_position = respawn_point.global_position
		player_instance.global_rotation = respawn_point.global_rotation
		add_child(player_instance)
		player_instance.connect("died", handle_unit_death)
		player_instance.set_camera_transform(camera_2d.get_path())
	else:
		var unit_instance = Unit.instantiate()
		unit_instance.global_position = respawn_point.global_position
		unit_instance.global_rotation = respawn_point.global_rotation
		unit_container.add_child(unit_instance)
		unit_instance.connect("died", handle_unit_death)
		set_unit_ai_to_advance_to_next_base(unit_instance)

func handle_unit_death():
	if unit_container.get_children().size() < max_units_alive and respawn_timer.is_stopped():
		respawn_timer.start() 

func _on_respawn_timer_timeout():
	var respawn_point = respawn_points[next_spawn_to_use]
	spawn_unit(respawn_point)
	if unit_container.get_children().size() < max_units_alive:
		respawn_timer.start()
	next_spawn_to_use += 1
	if next_spawn_to_use == respawn_points.size():
		next_spawn_to_use = 0
