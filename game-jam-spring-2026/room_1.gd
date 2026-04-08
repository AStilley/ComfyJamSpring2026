extends Sprite2D

var player_enter = false
@export var connectSpot: Node2D
#@export var player: Node2D
@export var next_room_num:int
var player: Node2D

signal camera(room_num)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_enter == true:
		if Input.is_action_just_pressed("Interact"):
			player.position = connectSpot.global_position
			camera.emit(next_room_num)
	pass

func _on_doorway_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_enter = true
	pass # Replace with function body.

func _on_doorway_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_enter = false
	pass # Replace with function body.
