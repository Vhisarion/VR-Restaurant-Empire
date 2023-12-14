class_name Pear

extends Product

var price = 1

func get_price() -> int:
	return price

func equals(other) -> bool:
	return other is Pear
