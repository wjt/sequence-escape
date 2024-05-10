extends CharacterBody2D

signal turn_finished

var inputs = {
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
	"move_up": Vector2.UP,
	"move_down": Vector2.DOWN,
}

func _ready():
	position = position.snapped(Vector2.ONE * Globals.TILE_SIZE)
	position += Vector2.ONE * Globals.TILE_SIZE/2

func handle_input() -> bool:
	for dir in inputs:
		if Input.is_action_just_pressed(dir):
			if $GridMovement.move(inputs[dir]):
				# FIXME: make animation names match actions
				$AnimatedSprite2D.play(dir.replace("move_", "walk_"))
			else:
				$AnimatedSprite2D.play(dir.replace("move_", "look_"))
			return true
	return false
