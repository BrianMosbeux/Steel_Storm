extends Node2D


@export var health: int = 100:
	set(value):
		health = clamp(value, 0, 150)
