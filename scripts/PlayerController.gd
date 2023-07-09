extends Node

onready var camera = $Camera

func get_controlled_monster():
	return get_node("CursorSelector").currently_selected

func get_camera_offset():
	return camera.transform.get_origin()

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("restart"):
			get_tree().reload_current_scene()

		if event.is_action_pressed("ui_cancel"):
			get_tree().reload_current_scene()
			#get_tree().quit()
