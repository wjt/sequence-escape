extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

func _process(_delta):
	if Input.is_action_pressed("move_right"):
		_animated_sprite.play("walk_right")
	elif Input.is_action_pressed("move_left"):
		_animated_sprite.play("walk_left")
	elif Input.is_action_pressed("move_up"):
		_animated_sprite.play("walk_up")
	elif Input.is_action_pressed("move_down"):
		_animated_sprite.play("walk_down")
	else:
		_animated_sprite.stop()
