class_name Banana

extends Product

func equals(other) -> bool:
	return other is Banana

func get_instance(_cls := "") -> Node:
	return super.get_instance("Banana") as Banana
