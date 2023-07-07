extends KinematicBody2D

var speed = 200  # speed in pixels/sec
var velocity = Vector2.ZERO

var TILE_SIZE = 16
var move_time = 1
var next_action = null
var direction = Vector2.ZERO


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
	print(state)
	if state == states.PLANNING:
		next_action = pick_next_action()
		return
	elif state == states.EXECUTE:
		state = states.MOVING # add other stuff here depending on next_action
		
	if state == states.MOVING:
		
		velocity = move_and_slide(velocity*TILE_SIZE)
		velocity = Vector2.ZERO
		state = states.PLANNING


	
	
func _on_Timer_timeout():

	if state == states.PLANNING:
		state = states.EXECUTE
