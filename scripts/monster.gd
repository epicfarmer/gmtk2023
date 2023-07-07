extends KinematicBody2D

var speed = 10  # speed in squares/sec
var velocity = Vector2.ZERO
var input = Vector2.ZERO
# goin to use these to determine animation state, etc.
enum control_states {CONTROLLED, UNCONTROLLED}
var current_state = control_states.UNCONTROLLED

var grid_size = 16

func set_controlled():
	input = Vector2(
		float(Input.is_action_pressed("right")) - float(Input.is_action_pressed("left")),
		float(Input.is_action_pressed("down")) - float(Input.is_action_pressed("up"))
	)
	current_state = control_states.CONTROLLED
	
func set_uncontrolled():
	input = Vector2.ZERO
	current_state = control_states.UNCONTROLLED

func _input(event):
	if current_state == control_states.CONTROLLED:
		process_input(event)


func process_input(event):

	if event is InputEventKey:
		if event.is_action_pressed('right'):
			input.x += 1
		if event.is_action_pressed('left'):
			input.x += -1
		if event.is_action_pressed('down'):
			input.y += 1
		if event.is_action_pressed('up'):
			input.y += -1
		if event.is_action_released('right'):
			input.x -= 1
		if event.is_action_released('left'):
			input.x -= -1
		if event.is_action_released('down'):
			input.y -= 1
		if event.is_action_released('up'):
			input.y -= -1
	# Make sure diagonal movement isn't faster
	velocity = input.normalized() * speed * grid_size

func _physics_process(_delta):
	velocity = move_and_slide(velocity)
