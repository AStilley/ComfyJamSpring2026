extends Node2D

@onready var sprite = $Sprite2D

func Startgame(object):
	sprite.texture = object
	
	var target_size = Vector2(300, 300) # desired size in pixels
	var tex_size = sprite.texture.get_size()
	
	sprite.scale = target_size / tex_size
	
	sprite.setup_dust()
func _ready() -> void:
	Startgame(load("res://icon.svg"))
	
