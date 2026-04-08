extends Camera2D

var positionNum = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_G):
		camPosition(1)
	if Input.is_key_pressed(KEY_H):
		camPosition(2)

func camPosition(positionNum) -> void:
	match positionNum:
		1: #First Room
			position.x = 360
			position.y = 240
		2: #Second Room
			position.x = 1080
			position.y = 240
		3:
			pass
	pass
