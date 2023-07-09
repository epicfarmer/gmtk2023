extends StaticBody2D

onready var sprite = $Sprite
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func open():
	print("Door opened")
	collision_layer = collision_layer & (~4)
	collision_mask = collision_mask & (~4)
	sprite.set_frame(0)
