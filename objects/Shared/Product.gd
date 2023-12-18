class_name Product

extends XRToolsPickable

@export var price: int = 0

func get_instance(cls := "") -> Node:
	return load(SceneUtils.product_scenes[cls]).instantiate()
