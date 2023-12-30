extends StaticBody3D

@onready var money_mesh = %Money.mesh 
var max_height: float
var max_y_pos: float
var min_y_pos = 0.03

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_height = money_mesh.height
	max_y_pos = %Money.position.y
	money_mesh.height = 0
	adjust_position(0)

func _on_world_1_environment_on_score_updated(height_percentage: float) -> void:
	var cilinder_height = clampf(max_height*height_percentage,0,max_height)
	money_mesh.height = cilinder_height
	adjust_position(cilinder_height)

func adjust_position(cilinder_height: float) -> void:
	%Money.position.y = min_y_pos + (cilinder_height/2.0)
	print("adjusted position to: ", %Money.position.y)
