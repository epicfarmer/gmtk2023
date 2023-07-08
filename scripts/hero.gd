extends KinematicBody2D

export var speed = 32  # speed in pixels/sec
var velocity = Vector2.ZERO
onready var sprite = $Sprite
onready var indicator = $ActionIndicator
onready var hitboxpoint = $hitboxpoint
onready var swordpoint = $swordpoint
onready var player = $AnimationPlayer

var TILE_SIZE = 16
var move_time = 1
var next_action = null
var direction = Vector2.ZERO
var destination = Vector2.ZERO # only used during move
var current_location = Vector2.ZERO
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
		return can_attack(position + action_tuple[1] * TILE_SIZE)
	if action_tuple[0] == actions.MOVE:
		#return true
		return can_move(position + action_tuple[1] * TILE_SIZE)

func _next_action(action, target):
	if target == null:
		return [action, directions[randi()%4]]
	var delta_position = (target.position - position)
	if action == actions.MOVE:
		delta_position = delta_position * target.get_direction_bias()
	if abs(delta_position.x) > abs(delta_position.y):
		delta_position.y = 0
	else:
		delta_position.x = 0
	return [action, delta_position.normalized()]

func plan(action, target):
	var potential_action = _next_action(action, target)
	if is_viable(potential_action):
		#print(potential_action)
		return potential_action
	return null

func distance_to(target):
	return position.distance_to(target.position)

func can_see(target_position):
	return check_raycast(target_position, 1)

func can_attack(target_position):
	var rc = not collider_check(target_position,$AttackingCollider)
	if rc:
		print("Can attack")
	else:
		print("Can't attack")
	return rc

func can_move(target_position):
	var rc = collider_check(target_position,$MovementCollider)
	if rc:
		print("Can move")
	else:
		print("Can't move")
	return rc

func collider_check(target_position, collider):
	print(target_position)
	collider.position = target_position - position
	var bodies_in_the_way = collider.get_overlapping_bodies()
	if bodies_in_the_way:
		print(bodies_in_the_way)
		return false
	return true

func check_raycast(target_position, mask):
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position, target_position, [self], mask)
	if result:
		return false
	return true

func choose_target(_action):
	var possible_targets = get_tree().get_nodes_in_group("Monsters")
	var chosen_target = null
	var min_distance = 10000000
	for target in possible_targets:
		if (distance_to(target) < min_distance) and can_see(target.position):
			min_distance = distance_to(target)
			chosen_target = target
	if chosen_target != null:
		return chosen_target
	#return PlayerController.get_controlled_monster()
	return null

func pick_next_action():
	print("A")
	for action in available_actions():
		print("  B")
		var target = choose_target(action)
		var outcome = plan(action, target)
		if not outcome == null:
			print("  C")
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
			hitboxpoint.rotation = 0
			swordpoint.rotation = 0
		if d.x < 0:
			sprite.set_flip_h(true)
			indicator.set_flip_h(true)
			hitboxpoint.rotation=PI
			swordpoint.rotation=PI
	if abs(d.y) > 0:
		indicator.rotation = PI/2

		if d.y > 0:
			indicator.set_flip_h(false)
			hitboxpoint.rotation=PI/2
			swordpoint.rotation = PI/2
		else:
			indicator.set_flip_h(true)
			hitboxpoint.rotation=3*PI/2
			swordpoint.rotation=3*PI/2


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
		if action_type == actions.ATTACK:
			indicator.set_frame(1)
			set_sprite_direction(action_dir)
		

		return
	elif state == states.EXECUTE:

		indicator.set_visible(false)
		var action_type = next_action[0]
		var action_dir = next_action[1]
		if action_type == actions.NO_ACTION:
			state = states.PLANNING
			return
		if action_type == actions.MOVE:
			state = states.MOVING
			current_location = position
			destination = position + action_dir*TILE_SIZE
			direction = action_dir
		if action_type == actions.ATTACK:
			player.play("basic_attack")
			state = states.ATTACKING
		next_action = null;
	if state == states.MOVING:
		var travel = (position - destination).normalized() 
		velocity = move_and_slide(direction * speed)
		if velocity == Vector2.ZERO and position.distance_to(destination) > 0.1:
			position = current_location
			state = states.PLANNING
		if position.distance_to(destination) < 0.1:
			position = destination
			state = states.PLANNING

		



		

func _on_Timer_timeout():

	if state == states.PLANNING and next_action != null:
		state = states.EXECUTE

func end_attack():
	if state == states.ATTACKING:
		state = states.PLANNING

