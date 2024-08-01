extends CharacterBody2D
class_name Enemy


@onready var health = $Health
@onready var ai = $AI
@onready var weapon = $Weapon


func ready():
	ai.initialize(self, weapon)

func _physics_process(delta):
	pass

func handle_hit():
	health.health -= 20
	if health.health <= 0:
		hide()
		#hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
