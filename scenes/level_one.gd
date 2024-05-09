extends Node2D

func _unhandled_input(event):
	if $Player.handle_input(event):
		$Enemy.move()
