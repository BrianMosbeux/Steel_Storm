extends Node2D


enum BaseCaptureStartOrder {
	FIRST,
	LAST
}


@export var base_capture_start_order: BaseCaptureStartOrder
@export var team_name: Team.TeamName = Team.TeamName.NEUTRAL
@export var Unit: PackedScene

var capturable_bases: Array = []

@onready var team = $Team


func initialize(capturable_bases: Array):
	team.team = team_name
	self.capturable_bases = capturable_bases
	for base in capturable_bases:
		base.connect("base_captured", self.handle_base_captured)
	check_for_next_capturable_base()


func handle_base_captured(_new_team: int):
	check_for_next_capturable_base()
	
	
func check_for_next_capturable_base():
	var next_base = get_next_capturable_base()
	if next_base:
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
			return base.global_position
	return null

func assign_next_capturable_base_to_units(base_location: Vector2):
	if base_location == null and base_location == Vector2.ZERO:
		return
	for unit in get_children():
		if unit == team:
			continue
		var ai = unit.ai
		ai.next_base = base_location
		ai.current_state = AI.State.ADVANCE
	
