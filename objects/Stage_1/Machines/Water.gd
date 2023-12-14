class_name Water

extends XRToolsPickable

var filling_objects = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for object in filling_objects:
		object.fill()


func _on_area_3d_body_entered(body):
	if (body is LemonJuice):
		filling_objects.push_back(body)


func _on_area_3d_body_exited(body):
	if (body is LemonJuice):
		filling_objects.remove_at(filling_objects.find(body))
