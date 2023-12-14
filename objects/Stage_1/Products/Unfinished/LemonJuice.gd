class_name LemonJuice

extends XRToolsPickable

# Will turn into lemonade when this value is 1
var water = 0

func fill():
	water += .1
	print("Filled with water, water level is now ", water)
	if (water >= 1):
		print("It's full, replace with lemonade")
		var lemonade = load("res://objects/Stage_1/Products/Finished/Juices/Lemonade.tscn").instantiate()
		get_tree().get_root().add_child(lemonade)
		lemonade.transform = transform
		
		if(is_picked_up()):
			var controller = get_picked_up_by_controller()
			var by: XRToolsFunctionPickup = get_picked_up_by_controller().find_child("FunctionPickup")
			let_go(Vector3.ZERO,Vector3.ZERO)
			by.drop_object()
			lemonade.pick_up(by, controller)
			by.picked_up_object = lemonade
		
		self.queue_free()
