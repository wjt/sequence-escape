extends StaticBody2D

@onready var switches = get_tree().get_nodes_in_group("switches")
var is_open = false

func _ready():
	for switch in switches:
		switch.connect("flipped", _on_switch_flipped)

func interact():
	if is_open:
		print("you win")

func _on_switch_flipped():
	var should_open = true
	for switch in switches:
		should_open = should_open && switch.switched_on

	if should_open and not is_open:
		is_open = true
		$AnimationPlayer.play("open")
	elif not should_open and is_open:
		is_open = false
		$AnimationPlayer.play_backwards("open")
