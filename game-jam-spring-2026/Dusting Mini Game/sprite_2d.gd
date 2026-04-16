extends Sprite2D

@export var wipe_radius := 20

var dust_image: Image
var dust_texture: ImageTexture
var shader_material: ShaderMaterial

func setup_dust():
	if texture == null:
		return

	shader_material = material as ShaderMaterial
	if shader_material == null:
		push_error("Material is not a ShaderMaterial")
		return

	var size = texture.get_size()

	dust_image = Image.create(size.x, size.y, false, Image.FORMAT_RF)
	dust_image.fill(Color(1, 1, 1))

	dust_texture = ImageTexture.create_from_image(dust_image)
	shader_material.set_shader_parameter("dust_mask", dust_texture)

func _ready():
	shader_material = material as ShaderMaterial

func wipe_at(global_pos: Vector2):
	if texture == null or dust_image == null or dust_texture == null:
		return

	var local = to_local(global_pos)
	var size = texture.get_size()

	var pixel_pos = local + size * 0.5

	var cx = int(pixel_pos.x)
	var cy = int(pixel_pos.y)

	for y in range(cy - wipe_radius, cy + wipe_radius):
		for x in range(cx - wipe_radius, cx + wipe_radius):

			if x < 0 or y < 0 or x >= size.x or y >= size.y:
				continue

			var dist = Vector2(x, y).distance_to(Vector2(cx, cy))
			if dist > wipe_radius:
				continue

			dust_image.set_pixel(x, y, Color(0, 0, 0))

	dust_texture.update(dust_image)

func _input(event):
	if event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		wipe_at(event.position)

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			print("Mouse released")
			if is_mostly_clear(0.45):
				print("Done")

func is_mostly_clear(percent_needed: float = 0.9, clear_threshold: float = 0.1) -> bool:
	if dust_image == null:
		return false

	var size = dust_image.get_size()
	var total_pixels = size.x * size.y
	var clear_pixels = 0
	
	for y in range(size.y):
		for x in range(size.x):
			var pixel = dust_image.get_pixel(x, y)
			if pixel.r <= clear_threshold:
				clear_pixels += 1
	
	var clear_ratio = float(clear_pixels) / float(total_pixels)
	return clear_ratio >= percent_needed
		
