extends CanvasLayer

@onready var _counter = $MarginContainer/StepCounter
@onready var _you_win = $MarginContainer/YouWin
@onready var _restart_button = $MarginContainer/HBoxContainer/Restart
@onready var _resume_button = $MarginContainer/HBoxContainer/Resume

signal resume
signal restart

func _ready():
	_you_win.hide()
	update_steps(0)

func update_steps(steps: int):
	_counter.text = "%d steps" % steps

func set_victory():
	_you_win.show()
	_resume_button.hide()

func _input(event: InputEvent):
	if event.is_action_pressed("pause"):
		# Avoid the game immediately re-pausing the game
		get_viewport().set_input_as_handled()
		resume.emit()

func _on_resume_pressed():
	resume.emit()

func _on_restart_pressed():
	restart.emit()
