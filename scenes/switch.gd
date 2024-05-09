extends StaticBody2D

@export_range(0, 2) var colour: int = 0:
	set(new_colour):
		colour = new_colour
		$Sprite2D.frame_coords.y = new_colour

@export var switched_on: bool = false:
	set(new_value):
		if switched_on == new_value:
			pass
		elif new_value:
			$AnimationPlayer.play("switch_on")
		else:
			$AnimationPlayer.play_backwards("switch_on")
		switched_on = new_value

signal flipped

func flip():
	self.switched_on = not self.switched_on
	flipped.emit()

func interact():
	flip()
