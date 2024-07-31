extends Area2D
class_name Bullet


var speed = 500
var direction: Vector2 = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity * delta 

func set_direction(dir: Vector2):
	direction = dir
	rotation += dir.angle()

func _on_bullet_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit()
		queue_free()
