extends Node2D
class_name AI

signal state_changed(new_state)


enum State {
	PATROL,
	ENGAGE,
	ADVANCE
}

@export var draw_path_line: bool = false


@onready var detection_zone = $DetectionZone
@onready var patrol_timer = $PatrolTimer
@onready var path_line = $PathLine


var current_state: State = -1:
	set(new_state):
		if new_state == current_state:
			return
		elif new_state == State.PATROL:
			origin = global_position
			patrol_timer.start()
			patrol_location_reached = true
		elif new_state == State.ADVANCE:
			if npc.has_reached_position(next_base):
				new_state = State.PATROL
			else:
				pass
		current_state = new_state
		state_changed.emit(current_state)
		
var target: CharacterBody2D = null
var weapon: Weapon = null
var npc: CharacterBody2D = null
var team: int = -1
#PATROL STATE
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false
var npc_velocity: Vector2 = Vector2.ZERO
#ADVANCE STATE
var next_base: Vector2 = Vector2.ZERO
#PATH FINDING
var path_finding: PathFinding

func _ready():
	current_state = State.PATROL
	path_line.visible = draw_path_line

func _physics_process(delta):
	path_line.global_rotation = 0
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				var path = path_finding.get_new_path(global_position, patrol_location)
				if path.size() > 1:
					var angle_to_path_1: float = (path[1] - npc.global_position).angle()
					var current_angle: float = rotate_toward(npc.global_rotation, angle_to_path_1, 2 * delta)
					npc.global_rotation = current_angle
					npc.velocity = Vector2(npc.speed, 0.0).rotated(current_angle)
					npc.move_and_slide()
					set_path_line(path)
					
					#
					#var angle_to_patrol_location: float = (path[1] - npc.global_position).angle()
					#npc.global_rotation = rotate_toward(npc.global_rotation, angle_to_patrol_location, 2 * delta)
					#if angle_to_patrol_location == npc.global_rotation:
						#npc.velocity = Vector2(npc.speed, 0.0).rotated(angle_to_patrol_location)
						##npc.position += npc.velocity * delta
						#npc.move_and_slide()
				else:
					patrol_location_reached = true
					npc.velocity = Vector2.ZERO
					patrol_timer.start()
					path_line.clear_points()
		State.ENGAGE:
			if target and weapon:
				var angle_to_target = (target.global_position - npc.global_position).angle()
				weapon.global_rotation = rotate_toward(weapon.global_rotation, angle_to_target, 2 * delta)
				if abs(weapon.global_rotation - angle_to_target) < 0.1:
					weapon.shoot()
		State.ADVANCE:
			var path = path_finding.get_new_path(global_position, next_base)
			if path.size() > 1:
				#var direction = npc.global_position.direction_to(path[1])
				#npc.velocity = direction * npc.speed
				#npc.move_and_slide()
				var angle_to_path_1: float = (path[1] - npc.global_position).angle()
				var current_angle: float = rotate_toward(npc.global_rotation, angle_to_path_1, 2 * delta)
				npc.global_rotation = current_angle
				npc.velocity = Vector2(npc.speed, 0.0).rotated(current_angle)
				npc.move_and_slide()
				set_path_line(path)
				#else:
					#print("angle not found")
					#print(angle_to_path_1 - npc.global_rotation)
			else:
				current_state = State.PATROL
				path_line.clear_points()
			#else:
				#var angle_to_next_base: float = (next_base - npc.global_position).angle()
				#npc.rotation = rotate_toward(npc.global_rotation, angle_to_next_base, 2 * delta)
				#if angle_to_next_base == npc.rotation:
					#npc.velocity = Vector2(npc.speed, 0.0).rotated(angle_to_next_base)
					##npc.position += npc.velocity * delta
					#npc.move_and_slide()
				
func initialize(npc: CharacterBody2D, weapon: Weapon, team: int):
	self.npc = npc
	self.weapon = weapon	
	self.team = team
	weapon.connect("weapon_out_of_ammo", handle_reload)
	
func set_path_line(points: Array):
	if not draw_path_line:
		return
	var local_points: Array = []
	for point in points:
		if point == points[0]:
			local_points.append(Vector2.ZERO)
		else:
			local_points.append(point - global_position)
	path_line.points = local_points
	

func _on_detection_zone_body_entered(body):
	if body.has_method("get_team") and body.get_team() != team:
		current_state = State.ENGAGE
		target = body

func _on_detection_zone_body_exited(body):
	if target and body == target:
		current_state = State.ADVANCE
		target = null

func _on_patrol_timer_timeout():
	var patrol_range: int = 150
	var random_x = randi_range(-patrol_range, patrol_range)
	var random_y = randi_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false

func handle_reload():
	weapon.start_reload()
