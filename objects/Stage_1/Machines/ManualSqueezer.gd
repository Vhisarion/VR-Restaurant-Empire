extends Node3D

var objects_inside: Array = []
var initial_position: Transform3D

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = self.transform
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Check if the lever is low enough for the ingredient to be squeezed
	if ($SqueezeLever/Lever.transform.y <= $SqueezeLever/SqueezeThreshold.transform.y):
		_squeeze()
	
	# Make sure the object doesn't move, it only rotates in the specified angle
	#TODO
	pass

func _squeeze():
	var product
	for object in objects_inside:
		match (object.get_type()):
			"Orange":
				product = load("res://objects/Stage_1/Products/Finished/Juices/OrangeJuice.tscn").instantiate()
			"Lemon":
				product = load("res://objects/Stage_1/Products/Finished/Juices/LemonJuice.tscn").instantiate()
		object.queue_free()
	pass
	product.transform = $ProductLocation.transform
	add_child(product)

func _on_area_3d_body_entered(body):
	objects_inside.append(body)
	pass # Replace with function body.

func _on_area_3d_body_exited(body):
	objects_inside.remove_at(objects_inside.find(body))
	pass # Replace with function body.
