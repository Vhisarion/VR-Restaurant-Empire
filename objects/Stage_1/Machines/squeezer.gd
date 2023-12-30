class_name Squeezer

extends Node3D

var squeeze_outcome = {
	"Orange": load(SceneUtils.product_scenes["OrangeJuice"]),
	"Lemon": load(SceneUtils.product_scenes["LemonJuice"])
}

func squeeze(type: String) -> void:
	var product = squeeze_outcome[type].instantiate()
	print("Squeezing ", type, "! Creating a ", product.name)
	product.transform = $ProductLocation.transform
	add_child(product)
