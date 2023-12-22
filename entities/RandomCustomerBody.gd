extends MeshInstance3D


@export var availableBodies: Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	var randomIndex = rng.randf_range(0, availableBodies.size())
	self.mesh = find_mesh_in_children(availableBodies[randomIndex]).mesh

func find_mesh_in_children(parent) -> MeshInstance3D:
	for child in parent.instantiate().get_children():
		if child is MeshInstance3D:
			return child
	
	return null
