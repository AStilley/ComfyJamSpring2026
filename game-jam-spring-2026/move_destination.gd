extends Node2D
@export var mat = ShaderMaterial.new()
@export var mat2 = ShaderMaterial.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func outline_off() -> void:
	$Sprite2D.material = mat
	pass
	
func outline_on() -> void:
	$Sprite2D.material = mat2
	pass
