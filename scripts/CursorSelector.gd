extends Area2D

var currently_selected

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	reset_selected()

func _input(event):
	if event is InputEventMouseMotion:
		transform.origin = event.position
	if event is InputEventMouseButton:
		currently_selected.set_uncontrolled()
		var other_bodies = get_overlapping_bodies()
		if len(other_bodies) > 0:
			other_bodies[0].set_controlled()
			other_bodies[0].select(self)
			currently_selected = other_bodies[0]

func reset_selected():
	currently_selected = self

func set_uncontrolled():
	pass

func set_controlled():
	pass

func get_direction_bias():
	return Vector2(1,1)
