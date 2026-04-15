extends Sprite2D

@export var wipe_radius: int = 16
@export var dust_fade_strength: float = 0.18
@export var wipe_to_transparent: bool = false

var working_image: Image
var working_texture: ImageTexture

func _ready() -> void:
	if texture == null:
		push_error("DustSprite has no texture assigned.")
		return

	# Get a CPU-side copy of the texture once.
	working_image = texture.get_image()
	if working_image == null:
		push_error("Could not get image data from texture.")
		return

	# Make sure the image format supports alpha editing cleanly.
	if working_image.get_format() != Image.FORMAT_RGBA8:
		working_image.convert(Image.FORMAT_RGBA8)

	# Create a new texture from the editable image and assign it.
	working_texture = ImageTexture.create_from_image(working_image)
	texture = working_texture


func wipe_at_global_position(global_pos: Vector2) -> void:
	if working_image == null:
		return

	# Convert global position into this sprite's local space.
	var local_pos: Vector2 = to_local(global_pos)

	# Sprite2D is centered by default, so convert local space to pixel space.
	var tex_size: Vector2 = texture.get_size()
	var pixel_pos := local_pos + tex_size * 0.5

	var center_x := int(round(pixel_pos.x))
	var center_y := int(round(pixel_pos.y))

	var min_x: int = max(center_x - wipe_radius, 0)
	var max_x: int = min(center_x + wipe_radius, int(tex_size.x) - 1)
	var min_y: int = max(center_y - wipe_radius, 0)
	var max_y: int = min(center_y + wipe_radius, int(tex_size.y) - 1)

	for y in range(min_y, max_y + 1):
		for x in range(min_x, max_x + 1):
			var dist := Vector2(x, y).distance_to(Vector2(center_x, center_y))
			if dist > wipe_radius:
				continue

			var color := working_image.get_pixel(x, y)

			if wipe_to_transparent:
				# Erase alpha like dust being removed.
				color.a = max(color.a - dust_fade_strength, 0.0)
			else:
				# Lighten toward white to imitate wiping away grime.
				color.r = lerp(color.r, 1.0, dust_fade_strength)
				color.g = lerp(color.g, 1.0, dust_fade_strength)
				color.b = lerp(color.b, 1.0, dust_fade_strength)

			working_image.set_pixel(x, y, color)

	# Update the displayed texture after editing.
	working_texture.update(working_image)
