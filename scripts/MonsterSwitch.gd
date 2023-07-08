extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var monsters = get_children()
var enabled = true
signal body_entered(_body)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enabled:
		print(monsters)
		if len(monsters) == 0:
			emit_signal("body_entered", self)
			print("signal emitted")
			enabled = false
