extends CharacterBody2D
class_name Player


@onready var weapon = $Weapon
@onready var health = $Health
@onready var team = $Team

var wheel_base: int = 70
var engine_power: int = 400
var braking: int = -400
var turn: int
var friction: float = -0.9
var drag: float = -0.0015
var steering_angle: float = 2.0
var steer_angle: float
var acceleration: Vector2
var aim_dir: Vector2
var dead_zone: float = .9



func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_player_move_input()
	apply_friction()
	calculate_direction()
	velocity += acceleration * delta
	
	get_player_aim_input()
	rotate_player_weapon(delta)
	move_and_slide()
	
func _unhandled_input(event):
	if event.is_action_pressed("shoot") and not weapon.animation_player.is_playing():
		weapon.shoot()
	elif event.is_action_pressed("reload"):
		weapon.start_reload()

func get_player_move_input():
	turn = int(Input.is_action_pressed("steer_right")) - int(Input.is_action_pressed("steer_left"))
	steer_angle = turn * deg_to_rad(steering_angle)
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking	

func get_player_aim_input():
	aim_dir = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
		
func rotate_player_weapon(delta):
	if aim_dir.length() > dead_zone:
		var aim_angle: float = aim_dir.angle()
		weapon.global_rotation = rotate_toward(weapon.global_rotation, aim_angle, 2 * delta)

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
	health.health -= 20
	if health.health <= 0:
		print("YOU DIED")

func get_team():
	return team.team
