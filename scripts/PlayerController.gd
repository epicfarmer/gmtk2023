extends Node

func get_controlled_monster():
	return get_node("CursorSelector").currently_selected
