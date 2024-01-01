class_name ManualSqueezer
extends Squeezer



var tracked_objects: Array = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for tracked_object in tracked_objects:
		check_rotation(tracked_object)
		
		if (tracked_object.motions_remaining == 0):
			print_rich("Object ", tracked_object.object, " has no motions remaining")
			process_tracked_object(tracked_object)

func check_rotation(tracked_object):
	var angle_difference = abs(tracked_object.last_motion_rotation) - abs(tracked_object.object.global_rotation.y)
	if (abs(angle_difference) >= 1):
		print_rich(tracked_object, " has rotated enough, substracting motion...")
		tracked_object.motions_remaining -= 1
		tracked_object.last_motion_rotation = tracked_object.object.rotation.y
		$SFX/FruitSqueeze.play()
		match(tracked_object.type):
			"Lemon":
				$VFX/LemonParticles.emitting = true
			"Orange":
				$VFX/OrangeParticles.emitting = true
	
func process_tracked_object(tracked_object):
	var object = tracked_object.object
	var type = tracked_object.type
	super.squeeze(type)
	tracked_objects.remove_at(find_body_in_tracked_objects(object))
	object.queue_free()

func _on_area_3d_body_entered(body):
	var type
	if (body is Orange):
		type = "Orange"
	elif (body is Lemon):
		type = "Lemon"
	else:
		# Not necessary to track other types
		return
	
	var tracked_object = {
		"last_motion_rotation": body.global_rotation.y, 
		"motions_remaining": 4,
		"object": body,
		"type": type
	}
	tracked_objects.push_back(tracked_object)

func _on_area_3d_body_exited(body):
	var body_index = find_body_in_tracked_objects(body)
	if body_index > -1:
		tracked_objects.remove_at(body_index)

func find_body_in_tracked_objects(body) -> int:
	for tracked_index in range(tracked_objects.size()):
		if (tracked_objects[tracked_index].object == body):
			return tracked_index
	return -1 
