extends Node2D


signal state_changed(new_state)


enum State {
	PATROL,
	ENGAGE
}


@onready var detection_zone = $DetectionZone
@onready var patrol_timer = $PatrolTimer


var current_state: int = -1:
	set(new_state):
		if new_state == current_state:
			return
		if new_state == State.PATROL:
			origin = global_position
			patrol_timer.start()
			patrol_location_reached = true
		else:
			print("no state detected")
		current_state = new_state
		state_changed.emit(current_state)
var target: CharacterBody2D = null
var weapon: Weapon = null
var npc: CharacterBody2D = null

var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false
var npc_velocity: Vector2 = Vector2.ZERO


func _ready():
	current_state = State.PATROL

func _physics_process(delta):
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				var angle_to_patrol_location: float = (patrol_location - npc.global_position).angle()
				npc.rotation = rotate_toward(npc.global_rotation, angle_to_patrol_location, 2 * delta)
				if angle_to_patrol_location == npc.rotation:
					npc.velocity = Vector2(npc.speed, 0.0).rotated(angle_to_patrol_location)
					npc.position += npc.velocity * delta
					npc.move_and_slide()
				if npc.global_position.distance_to(patrol_location) < 5:
					patrol_location_reached = true
					npc.velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			if target and weapon:
				var angle_to_target = (target.global_position - npc.global_position).angle()
				weapon.global_rotation = rotate_toward(weapon.global_rotation, angle_to_target, 2 * delta)
				if abs(weapon.global_rotation - angle_to_target) < 0.1:
					weapon.shoot()
				#var angle = (target.global_position - global_position).angle()
				#weapon.rotation = angle
				#npc.rotation = angle
				#npc.velocity = Vector2(npc.speed, 0.0).rotated(angle)
				
func initialize(npc: Enemy, weapon: Weapon):
	self.npc = npc
	self.weapon = weapon	

func _on_detection_zone_body_entered(body):
	if body.is_in_group("players"):
		current_state = State.ENGAGE
		target = body

func _on_detection_zone_body_exited(body):
	if body.is_in_group("players"):
		current_state = State.PATROL
		target = null




func _on_patrol_timer_timeout():
	var patrol_range: int = 150
	var random_x = randi_range(-patrol_range, patrol_range)
	var random_y = randi_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
