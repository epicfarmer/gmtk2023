extends Node

onready var camera = $Camera

func get_controlled_monster():
	return get_node("CursorSelector").currently_selected

func get_camera_offset():
	return camera.transform.get_origin()
