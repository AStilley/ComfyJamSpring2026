extends Node2D

#Player should be holding the object above them, Legend of Zelda style.
#The player cannot pick up another object while holding an object
#The room has a spot just for the specific item

@export var mat = ShaderMaterial.new()
@export var mat2 = ShaderMaterial.new()
@export var room_num: int
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@export var player : CharacterBody2D
@export var target_pos: Vector2
var dist_from_player: float
var type = "move"
@export var destination: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	outline_on()
	player = get_tree().get_first_node_in_group("Player")
	#print(player)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_key_pressed(KEY_Y)):
		outline_off()
	elif Input.is_key_pressed(KEY_U): 
		print("Turn on")
		outline_on()
	if (Input.is_key_pressed(KEY_P) and room_num > 0):
		#print(room_num)
		pass
	pass
func _physics_process(delta: float) -> void:
	#ray_cast_2d.target_position = to_local(player.global_position)
	ray_cast_2d.target_position = player.global_position - global_position
	target_pos = ray_cast_2d.target_position
	dist_from_player = player.global_position.distance_to(ray_cast_2d.global_position)
	
	#position.distance_to(ray_cast_2d.target_position)
	#print(player.name)
	#print(ray_cast_2d.target_position)
	#print(ray_cast_2d.is_colliding())
	#print(ray_cast_2d.get_collider())
	pass
	
func outline_off() -> void:
	$Sprite2D.material = mat
	pass
	
func outline_on() -> void:
	$Sprite2D.material = mat2
	pass
	
func get_distance() -> float:
	return dist_from_player
	
func activate_destination():
	destination.show()
	pass
func deactivate_destination():
	destination.hide()
	pass
func check_can_be_placed() -> bool:
	if player.global_position.distance_to(destination.global_position) < 30:
		rotation = 0
		deactivate_destination()
		global_position = destination.global_position
		self.reparent(get_tree().current_scene)
		self.remove_from_group("Room" + str(room_num))
		$Sprite2D.material = null
		return true
		
	return false
