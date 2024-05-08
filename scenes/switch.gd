extends StaticBody2D

@export_range(0, 2) var colour: int = 0:
	set(new_colour):
		colour = new_colour
		update_sprite()

@export var switched_on: bool = false:
	set(new_value):
		switched_on = new_value
		update_sprite()

func _ready():
	update_sprite()

func update_sprite():
	$Sprite2D.frame = (12 * colour) + (2 if switched_on else 0)
