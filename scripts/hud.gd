extends CanvasLayer


@onready var health_bar = $MarginContainer/Rows/BottomRow/HealthBar
@onready var current_ammo_label = $MarginContainer/Rows/BottomRow/CurrentAmmoLabel
@onready var max_ammo_label = $MarginContainer/Rows/BottomRow/MaxAmmoLabel


var player: Player
var health_tween: Tween

func set_player(player: Player):
	self.player = player
	set_new_health_bar_value(player.health.health)
	set_new_current_ammo_label_value(player.weapon.current_ammo)
	set_new_max_ammo_label_value(player.weapon.max_ammo)
	player.connect("player_health_changed", set_new_health_bar_value)
	player.weapon.connect("weapon_ammo_count_changed", set_new_current_ammo_label_value)

func set_new_health_bar_value(new_health: int):
	var origina_color: Color = Color("#ff5652")
	var transition_color: Color = Color("#ff8952")
	var bar_style = health_bar.get("theme_override_styles/fill")
	if health_tween:
		health_tween.kill()
	health_tween = create_tween()
	health_tween.tween_property(health_bar, "value", new_health, 0.5)
	health_tween.set_parallel()
	health_tween.tween_property(bar_style, "bg_color", transition_color, 0.2)
	health_tween.tween_property(bar_style, "bg_color", origina_color, 0.2).set_delay(0.2)
	
	#print(health_bar.value)
	#health_bar.value = new_health
	
func set_new_current_ammo_label_value(new_current_ammo: int):
	current_ammo_label.text = str(new_current_ammo)
	
func set_new_max_ammo_label_value(new_max_ammo: int):
	max_ammo_label.text = str(new_max_ammo)
