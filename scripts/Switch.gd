extends Area2D

onready var sprite = $Sprite

func set_pressed():
	sprite.set_frame(1)
