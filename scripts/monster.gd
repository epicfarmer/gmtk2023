extends KinematicBody2D

export var direction_bias = Vector2(1,1)
export(float) var timer_bias = 1

var speed = 5  # speed in squares/sec
var velocity = Vector2.ZERO
var input = Vector2.ZERO
var _timer = null
var targeted = false
onready var sprite = $Sprite
onready var selectsprite = $Sprite2
onready var targetsprite = $Sprite3
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
	print("Controlling ", self)
	current_state = control_states.CONTROLLED
	selectsprite.show()
	
func set_uncontrolled():
	input = Vector2.ZERO
	current_state = control_states.UNCONTROLLED
	selectsprite.hide()
	
func set_targeted():
	self.targeted = true
	
func set_untargeted():
	self.targeted = false

func _on_Timer_timeout():
	set_untargeted()

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
			sprite.set_flip_h(true)
		if d.x < 0:
			sprite.set_flip_h(false)

func _physics_process(_delta):
	velocity = move_and_slide(velocity)
	if velocity.length() > 0:
		get_node("AnimationPlayer").play("move")
	else:
		get_node("AnimationPlayer").play("idle")
	set_sprite_direction(input)
	var possible_targets = get_tree().get_nodes_in_group("Monsters")
	for monster in possible_targets:
		if monster.targeted and monster != self:
			self.set_untargeted()
	if self.targeted == true:
		targetsprite.show()
	if self.targeted == false:
		targetsprite.hide()

func take_damage():
	health = health - 1
	if health <= 0:
		die()

func die():
	if selected_by != null:
		print("Deselecting", self)
		selected_by.reset_selected()
	queue_free()

func _on_Hurtbox_area_entered(area):
	take_damage()
	
func _ready():
	set_uncontrolled()
	set_untargeted()
	get_node("AnimationPlayer").play("idle")
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(.5)
	_timer.set_one_shot(false)
	_timer.start()
