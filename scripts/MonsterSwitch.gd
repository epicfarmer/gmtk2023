extends Node2D

onready var monsters = get_children()
onready var scene = get_tree().get_root().get_child(0)
var enabled = true
signal body_entered(_body)

# Called when the node enters the scene tree for the first time.
func _ready():
	for monster in monsters:
		var initial_transform = monster.global_transform
		remove_child(monster)
		scene.call_deferred("add_child", monster)
		monster.set_deferred("transform",initial_transform)
	pass # Replace with function body.

func update_monsters():
	var index = len(monsters) - 1
	while(index >= 0):
		if not is_instance_valid(monsters[index]):
			monsters.remove(index)
		index = index - 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enabled:
		if len(monsters) == 0:
			emit_signal("body_entered", self)
			print("signal emitted")
			enabled = false
		else:
			update_monsters()
