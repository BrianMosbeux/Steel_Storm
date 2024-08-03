extends CharacterBody2D
class_name Enemy


@onready var health = $Health
@onready var ai = $AI
@onready var weapon = $Weapon
@onready var team = $Team


var speed = 100

func _ready():
	ai.initialize(self, weapon, team.team)

func _physics_process(delta):
	pass
	
func get_team():
	return team.team

func handle_hit():
	health.health -= 20
	if health.health <= 0:
		queue_free()
		$CollisionShape2D.set_deferred("disabled", true)
