class_name Pear

extends Product

func equals(other) -> bool:
	return other is Pear

func get_instance(_cls := "") -> Node:
	return super.get_instance("Pear") as Pear
