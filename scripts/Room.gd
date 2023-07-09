extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var monsters = get_children()
onready var scene = get_tree().get_root().get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	for monster in monsters:
		if monster.is_in_group("Monsters"):
			var initial_transform = monster.global_transform
			remove_child(monster)
			scene.call_deferred("add_child", monster)
			monster.set_deferred("transform",initial_transform)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
