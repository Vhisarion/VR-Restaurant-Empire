class_name AutomaticSqueezer
extends Squeezer

@export var preparation_time = 1.0
var ingredient: Product
var type: String
# Called when the node enters the scene tree for the first time.

func _on_orange_snap_zone_has_dropped():
	print('Called _on_orange_snap_zone_has_dropped')
	pass # Replace with function body.

func _on_orange_snap_zone_has_picked_up(what):
	print('Called _on_orange_snap_zone_has_picked_up with ' + what)
	if (what is Orange):
		type = "Orange"
	elif (what is Lemon):
		type = "Lemon"
	else: 
		return
	
	ingredient = what
	$PreparationTimer.start(preparation_time)

func _on_preparation_timer_timeout():
	var product = squeeze_outcome[type].instantiate()
	product.transform = $ProductLocation.transform
	add_child(product)
	
	$SnapZone.drop_object()
	ingredient.queue_free()
