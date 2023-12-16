class_name Customer

extends Node3D

signal on_customer_left(customer, location)

# The products the customer wants
var order: Array[Product]
# Copy of the original order to keep track of remaining items
var pending_products: Array[Product]

# The time the customer will wait for their order (seconds)
@export var max_patience: int

# Reference to the level controller
var level_controller: LevelController

# Reference to the location the customer is waiting at
var location: Node3D

# Item request locations
var item_request_locations: Array[Node3D] = []

func init(max_patience: int, products: Array[Product], level_controller: LevelController):
	order = products
	pending_products = order
	self.max_patience = max_patience
	self.level_controller = level_controller

func _ready():
	# Look for item request locations
	for number in range(9):
		var location = get_node_or_null("Tray/ItemRequest"+str(number+1))
		if (location != null):
			item_request_locations.push_back(location)

func _process(delta):
	_update_customer_color()

# Sum of the price of all products + tip
func calculate_price_of_order() -> int:
	return add_tip(calculate_price_of_products())

# Sum of the price of all products requested
func calculate_price_of_products() -> int:
	var sum = 0
	for product in order:
		sum += product.get_price()
	return sum

# Sum of the price of all pending products
func calculate_price_of_pending_products() -> int:
	var sum = 0
	for product in pending_products:
		sum += product.get_price()
	return sum

# Extra money depending on the customer's remaining patience
func add_tip(total: int) -> int:
	# Customers will pay up to 15% the total price as extra. They can pay 15%, 
	# 10%, 5% or 0% extra.
	var time_left = $PatienceTimer.time_left
	var tip = 0
	if (time_left > max_patience*0.75):
		tip = total*0.15
	elif (time_left > max_patience*0.5):
		tip = total*0.1
	elif (time_left > max_patience*0.5):
		tip = total*0.05
	
	return total + tip

# Show the order to the player and start the timer
func make_order():
	# Display the order in the ItemRequests
	for item in order:
		item_request_locations.pop_back().set_item(item)
		
	# Start the patience timer
	$PatienceTimer.start(max_patience)

# Customer leaves without fulfilling the order
func leave():
	level_controller.lose_points(calculate_price_of_products())
	on_customer_left.emit(self, location)
	destroy()

# Checks if the received product is part of the 
func product_received(received_product: Product):
	print("The customer received: ", received_product)
	var product_index = find_product_index(pending_products, received_product)
	var product_index_in_order = find_product_index(order, received_product)
	
	if (product_index != -1):
		# Remove product from pending products list
		pending_products.remove_at(product_index)
		print("The product ", received_product, " was removed from the order")
		
		# Remove the item request
		item_request_locations[product_index_in_order].queue_free()
		
		# Increase patience if there are still products left
		if (pending_products.size() > 0):
			print("There are still products in the order")
			$PatienceTimer.start($PatienceTimer.time_left + max_patience * 0.1)
		else:
			# Complete order if no products left
			pay()
		return
	else:
		print ("The product received wasn't in the order")
		# The product received isn't wanted
		level_controller.lose_points(1)

func find_product_index(array: Array[Product], product: Product) -> int:
	for index in range(array.size()):
		if (product.equals(array[index])):
			return index
	return -1

# The customer awards points to the player
func pay():
	level_controller.gain_points(calculate_price_of_order())
	destroy()

# Customer is removed from the scene
func destroy():
	self.queue_free()

func _on_patience_timer_timeout():
	leave()

func set_location(location: Node3D):
	self.location = location
	if (location != null):
		transform = location.transform

func _update_customer_color():
	if is_inside_tree():
		var color_value = $PatienceTimer.time_left/max_patience
		$CustomerBody.mesh.material.albedo_color = Color(1-color_value,color_value,0,0)

func _on_tray_snap_zone_has_picked_up(what):
	var product = find_product_child(what)
	product_received(product)
	($Tray/TraySnapZone as XRToolsSnapZone).picked_up_object = null
	printerr(($Tray/TraySnapZone as XRToolsSnapZone).picked_up_object)

func find_product_child(parent) -> Product:
	for child in parent.get_children():
		if child is Product:
			return child
	return null
