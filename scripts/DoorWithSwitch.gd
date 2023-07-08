extends Node2D

onready var switch = $Switch
onready var switchsprite = switch.get_child(0)
onready var door = $Door

# Called when the node enters the scene tree for the first time.
func _ready():
	switch.connect("body_entered", self, "_on_Switch_body_entered")
	pass # Replace with function body.

	
func _on_Switch_body_entered(_body):
	print("Door opened")
	door.open()
	switchsprite.set_frame(418)
