class_name ItemRequest

extends Node3D

@export var rotation_speed: float = 0.1

# Called when the node enters the scene tree for the first time.
func set_item(item: Product):
	# Hacer algo para saber qué escena hay que cargar
	#var instance = item.get_instance()
	var collisions = item.find_children("CollisionShape3D")
	for collision in collisions:
		collision.set_deferred("disabled", true)
	item.freeze = true
	item.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
	add_child(item)
