class_name Lemonade

extends JuiceProduct

var price = 3

func get_price():
	return price

func equals(other) -> bool:
	return super.equals(other) && (other is Lemonade)

func _on_straw_snap_zone_has_picked_up(straw):
	set_straw_from_pickable(straw)
	straw.queue_free()
	# Only allow one straw. Delete SnapZone afterwards
	$StrawSnapZone.queue_free()

func get_instance(_cls := "") -> Node:
	return super.get_instance("Lemonade") as Lemonade
