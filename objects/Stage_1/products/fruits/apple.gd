class_name Apple

extends Product

func equals(other) -> bool:
	return other is Apple

func get_instance(_cls := "") -> Node:
	return super.get_instance("Apple") as Apple
