extends CharacterBody2D
class_name Enemy


@onready var health = $Health


func _physics_process(delta):
	pass

	move_and_slide()

func handle_hit():
	health.health -= 20
	if health.health <= 0:
		hide()
		#hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
