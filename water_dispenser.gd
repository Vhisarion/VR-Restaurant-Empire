class_name WaterDispenser

extends Node3D

@export var preparation_time = 3.0
@onready var product = preload("res://objects/stage_1/products/juices/lemonade.tscn")

func dispense() -> void:
	$SnapZone.drop_object_and_free()
	
	var lemonade = (product.instantiate() as Lemonade)
	lemonade.picked_up_by = $SnapZone
	add_child(lemonade)
	$SnapZone.pick_up_object(lemonade)
	
	$VFX/WaterParticles.emitting = false
	$SnapZone.enabled = true
	$SFX/Pour.stop()

func _on_snap_zone_has_picked_up(what: Variant) -> void:
	if (!(what is LemonJuice)):
		return
	
	$SnapZone.enabled = false
	
	$PreparationTimer.start(preparation_time)
	$VFX/WaterParticles.emitting = true
	$SFX/Pour.play()
