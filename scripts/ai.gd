extends Node2D


signal state_changed(new_state)


enum State {
	PATROL,
	ENGAGE
}


@onready var detection_zone = $DetectionZone


var current_state: int = State.PATROL:
	set(new_state):
		if new_state == current_state:
			return
		current_state = new_state
		state_changed.emit(current_state)
var player: Player = null
var weapon: Weapon = null
var enemy: Enemy = null


func _process(delta):
	match current_state:
		State.PATROL:
			pass
		State.ENGAGE:
			if player and weapon:
				var angle_to_player = (player.global_position - enemy.global_position).angle()
				weapon.rotation = rotate_toward(weapon.global_rotation, angle_to_player, 2 * delta)
				if abs(weapon.rotation - angle_to_player) < 0.1:
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


