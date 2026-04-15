extends Node2D

#The player walks up to the object, does a minigame, then object swaps to the clean sprite

@export var mat = ShaderMaterial.new()
@export var mat2 = ShaderMaterial.new()
@export var dirt_sprite: Texture2D
@export var clean_sprite: Texture2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@export var player : CharacterBody2D
@export var target_pos: Vector2
var dist_from_player: float
var type = "dust"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	outline_on()
	$Sprite2D.texture = dirt_sprite
	player = get_tree().get_first_node_in_group("Player")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_key_pressed(KEY_Y)):
		outline_off()
	elif Input.is_key_pressed(KEY_U): 
		print("Turn on")
		outline_on()
	elif Input.is_key_pressed(KEY_I): 
		print("Turn on")
		clean()
	pass

func _physics_process(delta: float) -> void:
	#ray_cast_2d.target_position = to_local(player.global_position)
	ray_cast_2d.target_position = player.global_position - global_position
	target_pos = ray_cast_2d.target_position
	dist_from_player = player.global_position.distance_to(ray_cast_2d.global_position)

	#print(ray_cast_2d.is_colliding())
	#print(ray_cast_2d.get_collider())
	pass

func outline_off() -> void:
	$Sprite2D.material = mat
	pass
	
func outline_on() -> void:
	$Sprite2D.material = mat2
	pass

func clean() -> void:
	$Sprite2D.texture = clean_sprite
	pass
func get_distance() -> float:
	return dist_from_player
