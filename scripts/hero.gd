extends KinematicBody2D

export var speed = 32  # speed in pixels/sec
var velocity = Vector2.ZERO
onready var sprite = $Sprite
onready var indicator = $ActionIndicator

var TILE_SIZE = 16
var move_time = 1
var next_action = null
var direction = Vector2.ZERO
var destination = Vector2.ZERO # only used during move
var directions = [Vector2(0,1), Vector2(1,0), Vector2(0, -1), Vector2(-1, 0)]

# goin to use these to determine animation state, etc.
enum states {EXECUTE, PLANNING, MOVING, ATTACKING}
enum actions {ATTACK, MOVE, NO_ACTION}
var state = states.PLANNING

onready var PlayerController = get_parent().get_node("PlayerController")

func available_actions():
	return [actions.ATTACK, actions.MOVE]

func is_viable(action_tuple):
	if action_tuple[0] == actions.ATTACK:
		return false
	if action_tuple[0] == actions.MOVE:
		return true

func _next_action(action, target):
	if target == null:
		return [action, directions[randi()%4]]
	var delta_position = (target.position - position) * target.get_direction_bias()
	if abs(delta_position.x) > abs(delta_position.y):
		delta_position.y = 0
	else:
		delta_position.x = 0
	return [action, delta_position.normalized()]

func plan(action, target):
	var potential_action = _next_action(action, target)
	if is_viable(potential_action):
		return potential_action
	return null

func distance_to(target):
	return (target.position - position).distance_to(Vector2.ZERO)

func can_see(target):
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, target.global_position, [self], 1)
	print(len(result))
	if result:
		return false
	return true

func choose_target(_action):
	var possible_targets = get_tree().get_nodes_in_group("Monsters")
	var chosen_target = null
	var min_distance = 10000000
	for target in possible_targets:
		if (distance_to(target) < min_distance) and can_see(target):
			print("HERE")
			min_distance = distance_to(target)
			chosen_target = target
	if chosen_target != null:
		return chosen_target
	return null
	return PlayerController.get_controlled_monster()

func pick_next_action():
	for action in available_actions():
		var target = choose_target(action)
		var outcome = plan(action, target)
		if not outcome == null:
			return outcome
	return [actions.NO_ACTION, null]

# should probably create action base class to contain stuff
func add_action(_name, _direction):
	pass

func set_sprite_direction(d):
	if d.length() > 0:
		indicator.set_visible(true)
		indicator.position = d*TILE_SIZE
	else:
		indicator.set_visible(false)
		return
	if abs(d.x) > 0:
		indicator.rotation = 0

		if d.x > 0:
			sprite.set_flip_h(false)
			indicator.set_flip_h(false)
		if d.x < 0:
			sprite.set_flip_h(true)
			indicator.set_flip_h(true)
	if abs(d.y) > 0:
		indicator.rotation = PI/2

		if d.y > 0:
			indicator.set_flip_h(false)
		else:
			indicator.set_flip_h(true)

var cur_rand_direction = null;

func _physics_process(_delta):
	if state == states.PLANNING:
		next_action = pick_next_action()
		var action_type = next_action[0]
		var action_dir = next_action[1]
		if action_type == actions.NO_ACTION:
			set_sprite_direction(Vector2(0,0))
		if action_type == actions.MOVE:
			indicator.set_frame(0)
			set_sprite_direction(action_dir)
		
		# some display code here
		return
	elif state == states.EXECUTE:
		print(next_action)
		indicator.set_visible(false)
		var action_type = next_action[0]
		var action_dir = next_action[1]
		if action_type == actions.NO_ACTION:
			state = states.PLANNING
			return
		if action_type == actions.MOVE:
			state = states.MOVING
			destination = position + action_dir*TILE_SIZE
			print(destination)
			velocity = action_dir * speed
	if state == states.MOVING:
		velocity = move_and_slide(velocity)
		if velocity == Vector2.ZERO:
			state = states.PLANNING
		elif position.distance_to(destination) < 0.1:
			position = destination
			state = states.PLANNING
			velocity = Vector2.ZERO

func _on_Timer_timeout():

	if state == states.PLANNING:
		state = states.EXECUTE

	

