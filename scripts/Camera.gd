extends Camera2D

func _on_hero_room_entered(_room):
	print("Entering room")
	position = _room.get_position() - Vector2(100,100)# - Vector2f(width/2, height/2)
	_room.queue_free()
