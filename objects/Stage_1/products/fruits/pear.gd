class_name Pear

extends Product

var price = 1

func get_price() -> int:
	return price

func equals(other) -> bool:
	return other is Pear

func get_instance(_cls := "") -> Node:
	return super.get_instance("Pear") as Pear
