extends Area2D

func _on_body_entered(body):
	if body.is_in_group("Projectile"):
		#get_tree().current_scene.add_score()
		body.queue_free()
		print("Done")
		var node = get_tree().get_nodes_in_group("Position").pick_random()
		position = node.position
		


func _on_death_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Projectile"):
		body.queue_free()
		#increase the number to reflect the kid picking up ball
		
	
		
	#Paste number from
