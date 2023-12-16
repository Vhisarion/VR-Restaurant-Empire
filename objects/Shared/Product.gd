class_name Product

extends XRToolsPickable

func get_instance(cls := "") -> Node:
	return load(SceneUtils.product_scenes[cls]).instantiate()
