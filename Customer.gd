class_name Customer

extends Node3D

# The products the customer wants
var order: Array[Product]
# Copy of the original order to keep track of remaining items
var pending_products: Array[Product]

# The time the customer will wait for their order (seconds)
@export var max_patience: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init(max_patience: int, products: Array[Product]):
	$PatienceTimer.wait_time = max_patience
	order = products
	pending_products = order


func calculate_price_of_order() -> int:
	return add_tip(calculate_price_of_products())

# Sum of the price of all products requested
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
		tip = total*0.15
	elif (time_left > max_patience*0.5):
		tip = total*0.1
	elif (time_left > max_patience*0.5):
		tip = total*0.05
	
	return total + tip

func make_order():
	# TODO- Display the order they want and activate snap_zones/area3Ds
	# Start the patience timer
	$PatienceTimer.start()
	print("The customer is now asking for: ")
	print(order)

func leave():
	# TODO - anything related to the customer leaving
	self.queue_free()

func product_received(received_product: Product):
	print("The customer received: ", received_product)
	for product in order:
		if (product.equals(received_product)):
			order.remove_at(order.find(product))
			print("The product ", product, " was removed from the order")
			# Increase if there are still products left
			if (order.size() > 0):
				print("There are still products in the order")
				$PatienceTimer.time_left += max_patience * 0.1
			return
	
	print ("The product received wasn't in the order")
	# The product received isn't wanted
	# TODO - Anything related to a wrong product delivery
