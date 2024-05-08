extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

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

func _process(_delta):
	for dir in inputs:
		if Input.is_action_just_pressed(dir):
			# FIXME: make animation names match actions
			_animated_sprite.play(dir.replace("move_", "walk_"))
			var tween = self.create_tween()
			tween.set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(self, "position", position + inputs[dir] * tile_size, 0.5)
			break

#func _physics_process(delta):
	#get_input()
	#move_and_collide(velocity * delta)
