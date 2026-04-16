extends Node2D

@onready var sprite = $Sprite2D
var pos: Vector2
func Startgame(object, camera_pos):
	print("Test")
	print(object)
	pos = camera_pos
	#sprite.texture = object
	$Sprite2D.texture = object
	var target_size = Vector2(300, 300) # desired size in pixels
	var tex_size = $Sprite2D.texture.get_size()
	
	$Sprite2D.scale = target_size / tex_size
	
	$Sprite2D.setup_dust()
func _ready() -> void:
	#Startgame(load("res://icon.svg"))
	pass
