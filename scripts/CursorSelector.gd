extends Area2D

var currently_selected = self

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		transform.origin = event.position
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
		currently_selected.set_uncontrolled()
		var other_bodies = get_overlapping_bodies()
		print(other_bodies)
		if len(other_bodies) > 0:
			print("HERE")
			other_bodies[0].set_controlled()
			currently_selected = other_bodies[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_uncontrolled():
	pass

func set_controlled():
	pass
