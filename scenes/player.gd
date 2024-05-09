extends AnimatedSprite2D

var tile_size = 16  # FIXME

var inputs = {
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
	"move_up": Vector2.UP,
	"move_down": Vector2.DOWN,
}

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

func _unhandled_input(event):
	for dir in inputs:
		if Input.is_action_just_pressed(dir):
			var collided_with = $GridMovement.move(inputs[dir])
			if collided_with:
				pass
			else:
				# FIXME: make animation names match actions
				play(dir.replace("move_", "walk_"))
			break
