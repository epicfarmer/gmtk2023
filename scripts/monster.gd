extends KinematicBody2D

var speed = 10  # speed in squares/sec
var velocity = Vector2.ZERO
# goin to use these to determine animation state, etc.
enum control_states {CONTROLLED, UNCONTROLLED}
var current_state = control_states.CONTROLLED

var grid_size = 16



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
	velocity = Vector2.ZERO
	if Input.is_action_pressed('right'):
		print("Move Right")
		velocity.x = 1
	if Input.is_action_pressed('left'):
		print("Move Left")
		velocity.x = -1
	if Input.is_action_pressed('down'):
		print("Move Down")
		velocity.y = 1
	if Input.is_action_pressed('up'):
		print("Move Up")
		velocity.y = -1
	# Make sure diagonal movement isn't faster
	velocity = velocity.normalized() * speed * grid_size

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)

