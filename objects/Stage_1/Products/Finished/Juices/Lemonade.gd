class_name Lemonade

extends JuiceProduct

var price = 3

func get_price():
	return price

func equals(other) -> bool:
	return super.equals(other) && (other is Lemonade)

func _on_straw_snap_zone_has_picked_up(straw):
	set_straw_from_pickable(straw)
	# Only allow one straw. Delete SnapZone afterwards
	$StrawSnapZone.queue_free()
