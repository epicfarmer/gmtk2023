extends CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	disabled = false
	pass # Replace with function body.

func _on_Switch_body_entered(_body):
	print("Door opened")
	set_deferred("disabled", true)
