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

enum control_states {CONTROLLED, UNCONTROLLED}
var current_state = control_states.UNCONTROLLED


# goin to use these to determine animation state, etc.
enum states {EXECUTE, PLANNING, MOVING, ATTACKING}
var state = states.PLANNING
var actions = []

func pick_next_action():
	get_input()
	if velocity != Vector2.ZERO:
		return "move"
	pass # probably going to put raycast in each directionotherwise move in random direction

func get_input():
	if Input.is_action_just_pressed("ui_select"):
		print("HERE")
		if current_state == control_states.CONTROLLED:
			current_state = control_states.UNCONTROLLED
		else:
			current_state = control_states.CONTROLLED
		print("Current state is ", current_state)
	if current_state == control_states.CONTROLLED:
		process_input()

func process_input():
	if state != states.PLANNING:
		return
	if Input.is_action_pressed('right'):
		velocity.y = 0
		velocity.x = 1
	if Input.is_action_pressed('left'):
		velocity.y = 0
		velocity.x = -1
	if Input.is_action_pressed('down'):
		velocity.x = 0
		velocity.y = 1
	if Input.is_action_pressed('up'):
		velocity.x = 0
		velocity.y = -1


# should probably create action base class to contain stuff
func add_action(name, direction):
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

func _physics_process(delta):
	if state == states.PLANNING:
		if cur_rand_direction == null:
			cur_rand_direction = directions[randi()%4]
		next_action = pick_next_action()
		set_sprite_direction(cur_rand_direction)
		# some display code here
		return
	elif state == states.EXECUTE:
		indicator.set_visible(false)

		state = states.MOVING # add other stuff here depending on next_action
		if velocity == Vector2.ZERO:
			velocity = cur_rand_direction
		destination = position + velocity*TILE_SIZE
		velocity *= speed
		cur_rand_direction = null
			
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

	

