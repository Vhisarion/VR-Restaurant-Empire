extends Node3D

@export var item: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_snap_zone_has_dropped()


func _on_snap_zone_has_dropped():
	var snap_zone: XRToolsSnapZone = $SnapZone
	var instance = item.instantiate()
	add_child(instance)
	snap_zone.pick_up_object(instance)

	
