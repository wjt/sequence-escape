extends Node2D

var enemy_moving: bool = false
var game_finished: bool = false

func _unhandled_input(event):
	if not (game_finished or enemy_moving):
		$Player.handle_input()

func _on_player_turn_finished():
	if not game_finished:
		enemy_moving = true
		$Enemy.move()

func _on_enemy_turn_finished():
	enemy_moving = false

func _on_enemy_path_changed(path):
	$EnemyPath.points = path

func _on_door_escaped():
	game_finished = true
	print("you win")
