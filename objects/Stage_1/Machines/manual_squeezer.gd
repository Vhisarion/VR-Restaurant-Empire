class_name ManualSqueezer
extends Squeezer


const required_rotation = PI*35
var tracked_objects: Array = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for tracked_object in tracked_objects:
		check_rotation(tracked_object)
		
		if (tracked_object.accumulated_rotation >= required_rotation):
			process_tracked_object(tracked_object)

func check_rotation(tracked_object):
	var diff = abs(tracked_object.last_rotation - tracked_object.object.global_rotation.y)
	tracked_object.accumulated_rotation += diff
	
	if (tracked_object.accumulated_rotation/required_rotation > 0.25 && !tracked_object.vfx_1):
		play_squeeze_effects(tracked_object.type)
		tracked_object.vfx_1 = true
	elif (tracked_object.accumulated_rotation/required_rotation > 0.5 && !tracked_object.vfx_2):
		play_squeeze_effects(tracked_object.type)
		tracked_object.vfx_2 = true
	elif (tracked_object.accumulated_rotation/required_rotation > 0.75 && !tracked_object.vfx_3):
		play_squeeze_effects(tracked_object.type)
		tracked_object.vfx_3 = true
	
func process_tracked_object(tracked_object):
	play_squeeze_effects(tracked_object.type)
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
		"last_rotation": body.global_rotation.y,
		"accumulated_rotation": 0,
		"object": body,
		"type": type,
		"vfx_1": false,
		"vfx_2": false,
		"vfx_3": false,
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

func play_squeeze_effects(type: String) -> void:
	$SFX/FruitSqueeze.play()
	match(type):
		"Lemon":
			$VFX/LemonParticles.emitting = true
		"Orange":
			$VFX/OrangeParticles.emitting = true
