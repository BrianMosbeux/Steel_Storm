extends Node2D


signal state_changed(new_state)


enum State {
	PATROL,
	ENGAGE
}


@onready var detection_zone = $DetectionZone
@onready var patrol_timer = $PatrolTimer


var current_state: int = State.PATROL:
	set(new_state):
		if new_state == current_state:
			return
		if new_state == State.PATROL:
			origin = enemy.global_position
			patrol_timer.start()
			patrol_location_reached = true
		current_state = new_state
		state_changed.emit(current_state)
var player: Player = null
var weapon: Weapon = null
var enemy: Enemy = null

var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false
var enemy_velocity: Vector2 = Vector2.ZERO


func _process(delta):
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				var angle_to_patrol_location: float = (patrol_location - enemy.global_position).angle()
				enemy.rotation = rotate_toward(enemy.global_rotation, angle_to_patrol_location, 2 * delta)
				enemy.velocity = Vector2(enemy.speed, 0.0).rotated(angle_to_patrol_location)
				enemy.position += enemy.velocity * delta
				enemy.move_and_slide()
				if enemy.global_position.distance_to(patrol_location) < 5:
					patrol_location_reached = true
					enemy.velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			if player and weapon:
				var angle_to_player = (player.global_position - enemy.global_position).angle()
				print(angle_to_player)
				weapon.global_rotation = rotate_toward(weapon.global_rotation, angle_to_player, 2 * delta)
				if abs(weapon.global_rotation - angle_to_player) < 0.1:
					weapon.shoot()
				#var angle = (player.global_position - global_position).angle()
				#weapon.rotation = angle
				#enemy.rotation = angle
				#enemy.velocity = Vector2(enemy.speed, 0.0).rotated(angle)
				
func initialize(enemy: Enemy, weapon: Weapon):
	self.enemy = enemy
	self.weapon = weapon	

func _on_detection_zone_body_entered(body):
	if body.is_in_group("players"):
		current_state = State.ENGAGE
		player = body

func _on_detection_zone_body_exited(body):
	if body.is_in_group("players"):
		current_state = State.PATROL
		player = null




func _on_patrol_timer_timeout():
	var patrol_range: int = 50
	var random_x = randi_range(-patrol_range, patrol_range)
	var random_y = randi_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
