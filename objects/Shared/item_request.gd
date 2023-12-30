class_name ItemRequest

extends Node3D

@export var rotation_speed: float = 1.5
var displayed_item: Product

func _ready() -> void:
	# Start with random y rotation
	var rng = RandomNumberGenerator.new()
	var random_rotation = rng.randf_range(0, PI)
	rotate_y(random_rotation)
	rotate_x(0.25)

func _process(delta: float) -> void:
	rotate_y(rotation_speed*delta)

# Called when the node enters the scene tree for the first time.
func set_item(item: Product):
	# Hacer algo para saber qué escena hay que cargar
	var collisions = item.find_children("CollisionShape3D")
	for collision in collisions:
		collision.set_deferred("disabled", true)
	item.freeze = true
	item.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
	displayed_item = item
	add_child(item)
