class_name OrangeJuice

extends JuiceProduct

var price = 2

func get_price() -> int:
	return price

func equals(other) -> bool:
	return super.equals(other) && (other is OrangeJuice)


func _on_straw_snap_zone_has_picked_up(straw):
	if (straw is RedStraw):
		set_straw(StrawType.RED_STRAW)
	elif (straw is BlueStraw):
		set_straw(StrawType.BLUE_STRAW)
	else:
		set_straw(StrawType.NO_STRAW)
	
	# Only allow one straw. Delete SnapZone afterwards
	$StrawSnapZone.queue_free()

func get_instance(_cls := "") -> Node:
	return super.get_instance("OrangeJuice") as OrangeJuice
