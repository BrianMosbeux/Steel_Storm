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
	print(player, weapon)
	match current_state:
		State.PATROL:
			pass
		State.ENGAGE:
			if player and weapon:
				var direction = player.global_position - enemy.global_position
				weapon.rotation = rotate_toward(weapon.global_rotation, direction.angle(), 2 * delta)
				#var angle = (player.global_position - global_position).angle()
				#weapon.rotation = angle
				#enemy.rotation = angle
				#enemy.velocity = Vector2(enemy.speed, 0.0).rotated(angle)
				
func initialize(enemy: Enemy, weapon: Weapon):
	self.enemy = enemy
	self.weapon = weapon
	print(enemy, weapon)
	

func _on_detection_zone_body_entered(body):
	if body.is_in_group("players"):
		current_state = State.ENGAGE
		player = body
		print(weapon)
		print("ENGAGING")

func _on_detection_zone_body_exited(body):
	if body.is_in_group("players"):
		current_state = State.PATROL
		player = null
		print("PATROLING")

