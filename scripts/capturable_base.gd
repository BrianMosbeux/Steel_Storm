extends Area2D
class_name CapturableBase


signal base_captured(new_team)

@export var neutral_color: Color = Color("#ffffff")
@export var player_color: Color = Color("#388451")
@export var enemy_color: Color = Color("#d7000c")

var player_unit_count: int = 0
var enemy_unit_count: int = 0
var team_to_capture: int = Team.TeamName.NEUTRAL

@onready var team = $Team
@onready var sprite_2d = $Sprite2D
@onready var capture_timer = $CaptureTimer
@onready var collision_shape_2d = $CollisionShape2D


func get_random_position_within_capture_radius():
	var random_vec: Vector2 = (Vector2.RIGHT * randf()).rotated(randf_range(0, 2 * PI))
	var random_position: Vector2 = collision_shape_2d.global_position + random_vec * collision_shape_2d.shape.radius
	return random_position
	#var vec = (Vector2.RIGHT * rand_range(0, 100)).rotate(rand_range(0, PI))


func _on_body_entered(body):
	if body.has_method("get_team"):
		var body_team = body.get_team()
		if body_team == Team.TeamName.ENEMY:
			enemy_unit_count += 1
		elif body_team == Team.TeamName.PLAYER:
			player_unit_count += 1
		check_base_can_be_captured()

func _on_body_exited(body):
	if body.has_method("get_team"):
		var body_team = body.get_team()
		if body_team == Team.TeamName.ENEMY:
			enemy_unit_count -= 1
		elif body_team == Team.TeamName.PLAYER:
			player_unit_count -= 1
		check_base_can_be_captured()

func check_base_can_be_captured():
	var majority_team = get_team_with_majority()
	if majority_team == Team.TeamName.NEUTRAL:
		#print("No majority in base, stopping capture clock")
		team_to_capture = Team.TeamName.NEUTRAL
		capture_timer.stop()
	elif majority_team == team.team:
		#print("Owning team regained majority, stopping capture clock")
		team_to_capture = Team.TeamName.NEUTRAL
		capture_timer.stop()
	else:
		#print("New team has majority in base, starting capture clock")
		team_to_capture = majority_team
		capture_timer.start()

func get_team_with_majority():
	if player_unit_count == enemy_unit_count:
		return Team.TeamName.NEUTRAL
	elif player_unit_count > enemy_unit_count:
		return Team.TeamName.PLAYER
	else:
		return Team.TeamName.ENEMY
		
func set_new_team(new_team: int):
	team.team = new_team
	base_captured.emit(new_team)
	match new_team:
		Team.TeamName.NEUTRAL:
			sprite_2d.modulate = neutral_color
		Team.TeamName.PLAYER:
			sprite_2d.modulate = player_color
		Team.TeamName.ENEMY:
			sprite_2d.modulate = enemy_color

func _on_capture_timer_timeout():
	set_new_team(team_to_capture)
