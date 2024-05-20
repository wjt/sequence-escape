extends Node2D

var steps: int = 0
var enemy_moving: bool = false
var game_finished: bool = false

func _unhandled_input(event):
	if not (game_finished or enemy_moving):
		if $Player.handle_input():
			steps += 1
			$HUD.update_steps(steps)

func _input(event):
	if event.is_action_pressed("pause"):
		$HUD.show()
		get_tree().paused = true

func _on_player_turn_finished():
	if not game_finished:
		enemy_moving = true
		$Enemy.move()

func _on_enemy_turn_finished():
	enemy_moving = false

func _on_enemy_path_changed(path):
	$EnemyPath.points = path

func _on_door_escaped():
	get_tree().paused = true
	$HUD.set_victory()
	game_finished = true

func _on_hud_restart():
	get_tree().reload_current_scene()
