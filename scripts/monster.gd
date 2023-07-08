extends KinematicBody2D

export var direction_bias = Vector2(1,1)
export(float) var timer_bias = 1

var speed = 5  # speed in squares/sec
var velocity = Vector2.ZERO
var input = Vector2.ZERO
onready var sprite = $Sprite
onready var selectsprite = $SelectSprite
# goin to use these to determine animation state, etc.
enum control_states {UNCONTROLLED, CONTROLLED}
export var current_state = control_states.UNCONTROLLED
var selected_by = null
onready var health = 2

var grid_size = 16

func select(selector):
	selected_by = selector

func unselect():
	selected_by = null

func get_direction_bias():
	return self.direction_bias

func get_timer_bias():
	return self.timer_bias

func set_controlled():
	input = Vector2(
		float(Input.is_action_pressed("right")) - float(Input.is_action_pressed("left")),
		float(Input.is_action_pressed("down")) - float(Input.is_action_pressed("up"))
	)
	print("HERE")
	current_state = control_states.CONTROLLED
	selectsprite.show()
	
func set_uncontrolled():
	input = Vector2.ZERO
	current_state = control_states.UNCONTROLLED
	selectsprite.hide()

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

func set_sprite_direction(d):
	if abs(d.x) > 0:
		if d.x > 0:
			sprite.set_flip_h(false)
		if d.x < 0:
			sprite.set_flip_h(true)

func _physics_process(_delta):
	velocity = move_and_slide(velocity)
	set_sprite_direction(input)

func take_damage():
	health = health - 1
	if health <= 0:
		die()

func die():
	if selected_by != null:
		selected_by.reset_selected()
	queue_free()

func _on_Hurtbox_area_entered(area):
	take_damage()
	
func _ready():
	set_uncontrolled()
