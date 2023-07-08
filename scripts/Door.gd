extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func open():
	print("Door opened")
	$CollisionShape2D.set_deferred("disabled", true)
