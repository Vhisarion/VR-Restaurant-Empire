class_name Customer

extends Node3D

signal on_customer_left(customer, location)

# The products the customer wants
var order: Array[Product]
var total_order_price: int
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
	total_order_price = calculate_price_of_products()
	pending_products = order.duplicate(true)
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

func calculate_price_of_products() -> int:
	var sum = 0
	for product in order:
		sum += product.price
	return sum

# Extra money depending on the customer's remaining patience
func add_tip(total: int) -> int:
	# Customers will pay up to 15% the total price as extra. They can pay 15%, 
	# 10%, 5% or 0% extra.
	var time_left = $PatienceTimer.time_left
	var tip = 0
	if (time_left > max_patience*0.75):
		tip = total*0.5
	elif (time_left > max_patience*0.5):
		tip = total*0.33
	elif (time_left > max_patience*0.25):
		tip = total*0.25
	
	return total + tip

# Show the order to the player and start the timer
func make_order():
	# Display the order in the ItemRequests
	for item_index in range(order.size()):
		item_request_locations[item_index].set_item(order[item_index])
		
	# Start the patience timer
	$PatienceTimer.start(max_patience)

# Customer leaves without fulfilling the order
func leave():
	level_controller.lose_points(total_order_price)
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
		order[product_index_in_order].visible = false
		var item_request_location = item_request_locations[product_index]
		item_request_locations.remove_at(product_index)
		item_request_location.queue_free()
		
		# Increase patience if there are still products left
		if (pending_products.size() > 0):
			print("There are still products in the order")
			$PatienceTimer.start($PatienceTimer.time_left + max_patience * 0.1)
		else:
			# Complete order if no products left
			pay()
		
		$SFX/Delivery.play()
	else:
		print ("The product received wasn't in the order")
		# The product received isn't wanted
		level_controller.lose_points(1)
	
	received_product.queue_free()

func find_product_index(array: Array[Product], product: Product) -> int:
	for index in range(array.size()):
		if (array[index] != null && product.equals(array[index])):
			return index
	return -1

# The customer awards points to the player
func pay():
	print("Customer is about to pay. Order total is: ", total_order_price, " and with tips it's ", add_tip(total_order_price))
	level_controller.gain_points(add_tip(total_order_price))
	on_customer_left.emit(self, location)
	destroy()

# Customer is removed from the scene
func destroy():
	self.queue_free()

func _on_patience_timer_timeout():
	leave()

func set_location(location: Node3D):
	self.location = location
	if (location != null):
		global_transform = location.global_transform

func _update_customer_color():
	if is_inside_tree():
		%PatienceBar.value = $PatienceTimer.time_left/max_patience*100

func _on_tray_snap_zone_has_picked_up(what):
	product_received(what)
	($Tray/TraySnapZone as XRToolsSnapZone).picked_up_object = null

func find_product_child(parent) -> Product:
	for child in parent.get_children():
		if child is Product:
			return child
	return null
