extends CharacterBody2D


const speed = 200.0
var holding = false
@export var camera: Camera2D
@export var current_room: int
@export var interactable_objects = []
@export var trash: int
@export var background:Sprite2D
@export var animation_tree : AnimationTree
@onready var arr_head = ""
@onready var freeze = false
@onready var camera_pos = camera.global_position
var input
var camera_curr_pos: Vector2
var playback:AnimationNodeStateMachinePlayback

var dust_mini = preload("res://Dusting Mini Game/Dust Minigame.tscn")
func _ready() -> void:
	playback = animation_tree["parameters/playback"]
	current_room = 1
	trash = 0
	interactable_objects = get_tree().get_nodes_in_group("Room1")
	arr_head = interactable_objects[0].name
	SignalBus.minigame_done.connect(_on_done)
	pass
	
func _on_done():
	minigame_off()
	camera.global_position = camera_curr_pos
	pass
func _process(delta: float) -> void:
	#print(interactable_objects[0])
	pass
	
func get_input():
	#Movement
	input = Input.get_vector("left", "right", "up", "down")
	velocity = input * speed
	
	
	
	#check for distance
	if interactable_objects.size() > 1:
		interactable_objects.sort_custom(sort_by_distance)
	#-----------------------------------
	
	#Interact
	
	if interactable_objects.size() > 0:		
		if interactable_objects[0].dist_from_player < 50 :
			if interactable_objects[0].name == arr_head:
			#^^^ The player is close enough to the object
				#Highlight the object
				interactable_objects[0].outline_on()
			else:
				arr_head = interactable_objects[0]. name
				for i in interactable_objects:
					if i.has_method("outline_off"):
						i.outline_off()
				pass
		else:
			for i in interactable_objects:
				if i.has_method("outline_off"):
					i.outline_off()
				pass
	#^^^While there is an interactable object, that is close enough to the player
		#The object will be highlighted, When the player is far enough away, they are 
		#un-highlighted
	
	
	if Input.is_action_just_pressed("Interact"):
		
		if holding == true:
			#if placed properly
			if $"Item Hold".get_child(0).check_can_be_placed():
			#Can be placed here
				holding = false
				change_room(current_room)
				pass
			else:
			#Cannot place here
				pass
		
		if interactable_objects[0].dist_from_player < 50:
		#^^^ The player is close enough to the object
			#vvvHighlight the object
			interactable_objects[0].outline_on()
			#Check what kind of object it is: Move, Dust, Trash
			var x = interactable_objects[0].type
			match x:
				"move":
					print("This is a MOVE object")
					#Interaction with MOVE objects
					#Pick up the object
					if holding == false:
						interactable_objects[0].reparent($"Item Hold")
						interactable_objects[0].position = Vector2.ZERO
						holding = true
						interactable_objects[0].activate_destination()
						 
						
						#Player is holding an object above them
						pass


					#WHAT TO DO WITH PICKED UP OBJECT
					#WHERE IS THE DESTINATION
					pass
				"dust":
					print("This is a DUST object")
					#Interaction with DUST objects
						#Lead to minigame					
					camera_curr_pos = camera.global_position
					camera.global_position = camera_pos
					minigame_on()
					var instance = dust_mini.instantiate()
					instance.Startgame(interactable_objects[0].get_child(0).texture, camera.position)
					camera.add_child(instance)
					interactable_objects[0].clean()
					interactable_objects.erase(0)
					
					pass
				"trash":
					print("This is a TRASH object")
					trash += 1
					for i in interactable_objects:
						if i.type == "trash" and i.dist_from_player < 50:
							i.destroy()
							interactable_objects.erase(i)
						pass
					
					#The player could interact with the trashcan to start up
						#Trash throwing minigame
					
					pass
			pass

		pass
	#------------------------------------

func sort_by_distance(a,b):
	#The closer the object is, the closer to index 0 the object will be
	if a.dist_from_player < b.dist_from_player:
		return true
	return false
func update_animation_parameters():
	if input == Vector2.ZERO:
		return
	animation_tree["parameters/Idle/blend_position"]= input
	animation_tree["parameters/Walk/blend_position"] = input
	pass

func _physics_process(delta: float) -> void:
	if !freeze:
		get_input()
	move_and_slide()
	select_animation()
	update_animation_parameters()
func select_animation():
	if velocity == Vector2.ZERO:
		playback.travel("Idle")
	else:
		playback.travel("Walk")
		pass
	pass	
func change_room(room_num) -> void:
		current_room = room_num
		match current_room:
			1:
				interactable_objects = get_tree().get_nodes_in_group("Room1")
				pass
			2:
				interactable_objects = get_tree().get_nodes_in_group("Room2")
				pass
			3:
				interactable_objects = get_tree().get_nodes_in_group("Room3")
				pass

		#Get the objects in this room

func minigame_on():
	freeze = true
	background.show()
	pass
func minigame_off():
	freeze = false	
	background.hide()
	pass
