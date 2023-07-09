extends Area2D

onready var sprite = $Sprite

func _ready():
	self.connect("body_entered", self, "_on_Hitbox_body_entered")
	self.connect("body_exited", self, "_on_Hitbox_body_exited")

func _on_Hitbox_body_entered(_body):
	sprite.set_frame(0)
	_body.take_damage()

func _on_Hitbox_body_exited(_body):
	sprite.set_frame(0)
