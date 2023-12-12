class_name LevelController

extends Node3D

@export var number_of_customers : int
@export var max_time : int

var auxTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	var orangeJuice = OrangeJuice.new() as Product
	var lemonade = Lemonade.new() as Product
	var customer = load("res://Customer.tscn").instantiate()
	print(typeof(lemonade))
	customer.init(20, [lemonade, orangeJuice])
	customer.make_order()
	OS.delay_msec(1000)
	customer.product_received(lemonade)
	OS.delay_msec(1000)
	customer.product_received(orangeJuice)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
