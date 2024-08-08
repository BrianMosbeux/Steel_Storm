extends CharacterBody2D
class_name NPC


signal died


@onready var health = $Health
@onready var ai = $AI
@onready var weapon = $Weapon
@onready var team = $Team
@onready var collision_shape_2d = $CollisionShape2D



var speed = 100


func _ready():
	ai.initialize(self, weapon, team.team)
	
func has_reached_position(location:Vector2):
	return global_position.distance_to(location) < 5

func get_team():
	return team.team

func handle_hit():
	health.health -= 20
	if health.health <= 0:
		died.emit()
		queue_free()
		$CollisionShape2D.set_deferred("disabled", true)
