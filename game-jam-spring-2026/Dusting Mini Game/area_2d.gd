extends Area2D

@export var dust_sprite_path: NodePath
var dust_sprite

func _ready() -> void:
	dust_sprite = get_node(dust_sprite_path)

func _process(_delta: float) -> void:
	global_position = get_local_mouse_position()
	print(position)
	#dust_sprite.wipe_at(global_position)
	pass
