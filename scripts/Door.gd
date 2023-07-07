extends CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	disabled = false
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	disabled = true

func is_hero():
	return false
