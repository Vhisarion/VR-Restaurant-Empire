class_name AutomaticSqueezer
extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set preparation timer to the correct time
	$PreparationTimer.wait_time = 1.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_orange_snap_zone_has_dropped():
	print('Called _on_orange_snap_zone_has_dropped')
	pass # Replace with function body.

func _on_orange_snap_zone_has_picked_up(what):
	print('Called _on_orange_snap_zone_has_picked_up with ' + what)
	$PreparationTimer.start()
	pass # Replace with function body.

func _on_preparation_timer_timeout():
	print('preparation finished, placing product')
	var product = null
	match ($OrangeSnapZone.picked_up_object.get_type()):
		"Orange":
			product = load("res://objects/Stage_1/Products/Finished/Juices/OrangeJuice.tscn").instantiate()
		"Lemon":
			product = load("res://objects/Stage_1/Products/Finished/Juices/LemonJuice.tscn").instantiate()

	$OrangeSnapZone.picked_up_object = null
	product.transform = $ProductLocation.transform
	add_child(product)
