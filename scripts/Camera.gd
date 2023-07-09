extends Camera2D

func _on_hero_room_entered(_room):
	print("Entering room")
	position = _room.get_global_position() - Vector2(136,72)# - Vector2f(width/2, height/2)
