extends StaticBody2D

@onready var switches = get_tree().get_nodes_in_group("switches")
var is_open = false

func _ready():
	for switch in switches:
		switch.connect("flipped", _on_switch_flipped)

func open():
	is_open = true
	$AnimationPlayer.play("open")
	# Move to another physics layer so that the player can walk on top of it
	# to win the level.
	# FIXME: need to check this is a sane way of detecting for level completion
	#$CollisionShape2D.collision_layer = 2

func interact():
	if is_open:
		print("you win")

func _on_switch_flipped():
	var should_open = true
	for switch in switches:
		should_open = should_open && switch.switched_on

	if should_open:
		open()
