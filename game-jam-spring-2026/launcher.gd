extends Node2D
@onready var line = $Line
@export var projectile_scene: PackedScene
@export var power: float = 800.0

func launch():
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = $SpawnPoint.global_position
	
	# Get direction from rotation
	var direction = (get_global_mouse_position() - global_position).normalized()
	
	projectile.linear_velocity = direction * power

func _input(event):
	if event.is_action_pressed("ui_accept"):
		launch()
		
func _process(delta):
	look_at(get_global_mouse_position())
	var mouse_pos = get_global_mouse_position()
	
	# Rotate launcher
	look_at(mouse_pos)
	
	# Direction from launcher to mouse
	var direction = mouse_pos - global_position
	
	# Limit line length (so it doesn’t get huge)
	var max_length = 150
	if direction.length() > max_length:
		direction = direction.normalized() * max_length
	
	# Draw line (local space)
	line.points = [
		Vector2.ZERO,
		to_local(global_position + direction)
	]
