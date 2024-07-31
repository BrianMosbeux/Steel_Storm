extends CharacterBody2D
class_name Player


signal player_shot(bullet, bullet_start_location, bullet_dir)


@onready var weapon = $Weapon
@onready var health = $Health


var wheel_base: int = 70
var engine_power: int = 400
var braking: int = -400
var turn: int
var friction: float = -0.9
var drag: float = -0.0015
var steering_angle: float = 2.0
var steer_angle: float
var acceleration: Vector2


func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_player_move_input()
	apply_friction()
	calculate_direction()
	velocity += acceleration * delta
	move_and_slide()
	
func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		weapon.shoot()

func get_player_move_input():
	turn = int(Input.is_action_pressed("steer_right")) - int(Input.is_action_pressed("steer_left"))
	steer_angle = turn * deg_to_rad(steering_angle)
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force
	
func calculate_direction():
	rotation += steer_angle
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	var new_heading = (front_wheel - rear_wheel).normalized()
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = new_heading * velocity.length()
	if d <= 0:
		velocity = -new_heading * velocity.length()
		
func handle_hit():
	health.health -= 50
	if health.health <= 0:
		print("YOU DIED")

func _on_weapon_weapon_fired(bullet, bullet_start_postion, bullet_direction):
	player_shot.emit(bullet, bullet_start_postion, bullet_direction)
