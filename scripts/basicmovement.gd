extends KinematicBody2D

var speed = 10  # speed in pixels/sec
var velocity = Vector2.ZERO

var TILE_SIZE = 16
var move_time = 1
var next_action = null
var direction = Vector2.ZERO
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
	if Input.is_action_pressed('right'):
		velocity.x = 1
	if Input.is_action_pressed('left'):
		velocity.x = -1
	if Input.is_action_pressed('down'):
		velocity.y = 1
	if Input.is_action_pressed('up'):
		velocity.y = -1


# should probably create action base class to contain stuff
func add_action(name, direction):
	pass
	
func _physics_process(delta):
	if state == states.PLANNING:
		next_action = pick_next_action()
		# some display code here
		return
	elif state == states.EXECUTE:
		state = states.MOVING # add other stuff here depending on next_action
		
	if state == states.MOVING:
		if velocity == Vector2.ZERO:
			velocity = directions[randi()%4]
		velocity = move_and_slide(velocity*TILE_SIZE/delta)
		velocity = Vector2.ZERO
		state = states.PLANNING

func _on_Timer_timeout():

	if state == states.PLANNING:
		state = states.EXECUTE

	

