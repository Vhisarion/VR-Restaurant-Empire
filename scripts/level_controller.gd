class_name LevelController

extends Node

signal on_score_updated(height_percentage: float)
signal points_gained()
signal on_level_ended(cleared: bool)

# Level settings
var required_score : int

# Score
var current_score: int

var customers: Array[Customer] = []
var customer_total: int
var served_customers = 0
var arrival_timers: Array[Timer] = []
var customer_locations: Array[Node3D] = []
var occupied_locations: Array[bool] = []
var customer_queue: Array[Customer] = []

# Constants
const INT_MAX = 9223372036854775807

# Player
@export var player: XROrigin3D

func _process(delta):
	# Check if there are customers in the queue.
	if (customer_queue.size() != 0):
		# If there are, add them to the empty locations (if any)
		for index in range(customer_locations.size()):
			if (!occupied_locations[index]):
				var customer = customer_queue.pop_front()
				customer.set_location(customer_locations[index])
				add_child(customer)
				customer.make_order()
				occupied_locations[index] = true
				break

# Called when the node enters the scene tree for the first time.
func _ready():
	# Parse level JSON file
	var json = read_json_file()
	
	# Initialize level settings
	required_score = json.settings.required_score
	
	# Initialize all customers for the level
	initialize_customers(json.customers)
	start_arrival_timers()
	
	# Remove machines and sources not enabled in the level
	configure_machines(json.settings.machines)
	configure_sources(json.settings.sources)
	
	# Remove tutorials not enabled in the level
	configure_tutorials(json.settings.tutorials)
	
	# Look for customer locations in the current environment
	configure_customer_locations()
	
	player.transitioned.connect(return_to_selection_world)

func configure_machines(json_machines):
	var machines = %Machines.get_children()
	for machine in machines:
		if (!json_machines.has(machine.name)):
			machine.queue_free()

func configure_sources(json_sources):
	var sources = %Sources.get_children()
	for source in sources:
		if (!json_sources.has(source.name)):
			source.queue_free()

func configure_tutorials(json_tutorials):
	var tutorials = %Tutorials.get_children()
	for tutorial in tutorials:
		if (!json_tutorials.has(tutorial.name)):
			tutorial.queue_free()

func configure_customer_locations():
	for number in range(9):
		var location = get_node_or_null("CustomerLocations/CustomerLocation"+str(number+1))
		if (location != null):
			customer_locations.push_back(location)
			occupied_locations.push_back(false)

func initialize_customers(json_customers: Array):
	for customer_settings in json_customers:
		var customer = create_customer(customer_settings)
		create_customer_arrival_timer(customer_settings.arrival, customer)
		customer.on_customer_left.connect(_on_customer_left)
		customers.push_back(customer)
	customer_total = customers.size()

func create_customer(settings) -> Customer:
	var customer = load("res://entities/customer.tscn").instantiate()
	customer.init(settings.max_patience, parse_order(settings.order), self)
	return customer

func parse_order(json_orders) -> Array[Product]:
	var order: Array[Product] = []
	for json_product in json_orders:
		var product : Product = null
		match(json_product.product):
			"Lemonade":
				product = load(SceneUtils.product_scenes["Lemonade"]).instantiate()
				product.set_straw(JuiceProduct.StrawType[json_product.modifiers.straw_type])
			"OrangeJuice":
				product = load(SceneUtils.product_scenes["OrangeJuice"]).instantiate()
				product.set_straw(JuiceProduct.StrawType[json_product.modifiers.straw_type])
			"Apple":
				product = load(SceneUtils.product_scenes["Apple"]).instantiate()
			"Banana": 
				product = load(SceneUtils.product_scenes["Banana"]).instantiate()
		if (product != null):
			order.push_back(product)
		else:
			printerr("Error parsing product, type not supported")
	return order 

func create_customer_arrival_timer(arrival: int, customer: Customer):
	var arrival_timer = Timer.new()
	arrival_timer.one_shot = true
	arrival_timer.timeout.connect(spawn_customer.bind(customer))
	arrival_timer.wait_time = arrival
	add_child(arrival_timer)
	arrival_timers.push_back(arrival_timer)

func spawn_customer(customer):
	enter_queue(customer)

func start_arrival_timers():
	for timer in arrival_timers:
		timer.start()

func read_json_file():
	var file = FileAccess.open(Main.selected_level, FileAccess.READ)
	var content_as_dictionary = JSON.parse_string(file.get_as_text())
	return content_as_dictionary

func gain_points(amount: int):
	current_score += amount
	on_score_updated.emit(float(current_score)/float(required_score*1.1))
	points_gained.emit()
	$SFX/Coins.play()
	print("Player earned ", amount, " points and now has a total of ", current_score, " points")

func lose_points(amount: int):
	current_score = clamp(current_score-amount,0,INT_MAX)
	on_score_updated.emit(float(current_score)/float(required_score*1.1))
	$SFX/CustomerAngry.play()

func _on_customer_left(customer, location):
	var location_index = customer_locations.find(customer.location)
	occupied_locations[location_index] = false
	customer.set_location(null)
	served_customers += 1
	if (served_customers == customer_total) :
		end_level()

func enter_queue(customer: Customer):
	customer_queue.push_back(customer)

func end_level() -> void:
	if (current_score >= required_score):
		# Win
		Main.complete_current_level()
		on_level_ended.emit(true)
	else:
		# Lose
		on_level_ended.emit(false)
	
	var return_timer = get_tree().create_timer(5.0)
	return_timer.connect("timeout", start_scene_transition)
	print("End of level! Total score: ", current_score)

func start_scene_transition() -> void:
	player.transition()

func return_to_selection_world() -> void:
	get_tree().change_scene_to_packed.bind(Main.world_environments[0]).call_deferred()
