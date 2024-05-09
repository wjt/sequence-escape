extends Node2D
@export var self_node: Node2D
@export var speed: float = .25

var moving_direction: Vector2 = Vector2.ZERO

func move(direction: Vector2) -> bool:
	if moving_direction.length() == 0 && direction.length() > 0:
		var movement = Vector2.DOWN
		if direction.y > 0: movement = Vector2.DOWN
		elif direction.y < 0: movement = Vector2.UP
		elif direction.x > 0: movement = Vector2.RIGHT
		elif direction.x < 0: movement = Vector2.LEFT

		$RayCast2D.target_position = movement * 16
		$RayCast2D.force_raycast_update() # Update the `target_position` immediately
		
		# Allow movement only if no collision in next tile
		if !$RayCast2D.is_colliding():
			moving_direction = movement

			var new_position = self_node.global_position + (moving_direction * 16)

			var tween = create_tween()
			tween.tween_property(self_node, "position", new_position, speed).set_trans(Tween.TRANS_LINEAR)
			tween.tween_callback(func(): moving_direction = Vector2.ZERO)
			return true
		else:
			print(self_node.name, " collided with ", $RayCast2D.get_collider().name)

	return false

func get_collider() -> Object:
	return $RayCast2D.get_collider()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set movement direction as DOWN by default
	$RayCast2D.target_position = Vector2.DOWN * 16

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
