class_name AutomaticSqueezer
extends Squeezer

@export var preparation_time = 2.0
@onready var snap_zone: XRToolsSnapZone = $SnapZone
var type: String

func _on_snap_zone_has_picked_up(what):
	if what.is_queued_for_deletion():
		return
	
	print('Called _on_snap_zone_has_picked_up with ', what.name)
	if (what is Orange):
		type = "Orange"
	elif (what is Lemon):
		type = "Lemon"
	else: 
		return
	
	$PreparationTimer.start(preparation_time)
	snap_zone.enabled = false

func _on_preparation_timer_timeout():
	super.squeeze(type)
	
	var ingredient = snap_zone.picked_up_object
	snap_zone.drop_object()
	ingredient.queue_free()
	
	snap_zone.enabled = true
