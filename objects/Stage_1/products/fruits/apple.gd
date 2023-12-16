class_name Apple

extends Product

var price = 1

func get_price() -> int:
	return price

func equals(other) -> bool:
	return other is Apple

func get_instance(_cls := "") -> Node:
	return super.get_instance("Apple") as Apple
