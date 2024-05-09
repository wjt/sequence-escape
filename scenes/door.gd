extends StaticBody2D

func open():
	$AnimationPlayer.play("open")
	# Move to another physics layer so that the player can walk on top of it
	# to win the level.
	# FIXME: need to check this is a sane way of detecting for level completion
	$CollisionShape2D.collision_layer = 2
