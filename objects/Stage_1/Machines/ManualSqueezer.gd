class_name ManualSqueezer
extends Node3D

var squeeze_outcome = {
	"Orange": load("res://objects/Stage_1/Products/Finished/Juices/OrangeJuice.tscn"),
	"Lemon": load("res://objects/Stage_1/Products/Unfinished/LemonJuice.tscn")
}

var tracked_objects: Array = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for tracked_object in tracked_objects:
		check_rotation(tracked_object)
		
		if (tracked_object.motions_remaining == 0):
			print_rich("Object ", tracked_object.object, " has no motions remaining")
			_squeeze(tracked_object)

func check_rotation(tracked_object):
	var angle_difference = abs(tracked_object.last_motion_rotation) - abs(tracked_object.object.global_rotation.y)
	if (abs(angle_difference) >= 1):
		print_rich(tracked_object, " has rotated enough, substracting motion...")
		tracked_object.motions_remaining -= 1
		tracked_object.last_motion_rotation = tracked_object.object.rotation.y
	
func _squeeze(tracked_object):
	var object = tracked_object.object
	var type = tracked_object.type
	print("Squeezing object ", object, " of type ", type)
	var product = squeeze_outcome[type].instantiate()
	tracked_objects.remove_at(tracked_objects.find(tracked_object))
	object.queue_free()
	product.transform = $ProductLocation.transform
	add_child(product)

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
	var body_index = tracked_objects.find(func(tracked_object): return tracked_object.object.equals(body))
	if body_index > -1:
		tracked_objects.remove_at(body_index)
