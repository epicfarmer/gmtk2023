extends KinematicBody2D

var speed = 200  # speed in pixels/sec
var velocity = Vector2.ZERO

var grid_size = 16

# goin to use these to determine animation state, etc.
enum states {MOVING, WAITING, ATTACKING}


func pick_next_action():
	pass # probably going to put raycast in each directionotherwise move in random direction

func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	# Make sure diagonal movement isn't faster
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
