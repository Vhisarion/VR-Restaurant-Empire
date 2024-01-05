class_name EOLTruck

extends Node3D

const cleared_text = "LEVEL CLEARED!"
const failed_text = "LEVEL FAILED!"

@export var speed: float
var driving = false

func _process(delta: float) -> void:
	if (driving):
		position.x += speed*delta

func _on_world_1_environment_on_level_ended(cleared: bool) -> void:
	visible = true
	driving = true
	
	if (cleared):
		$MessageLeft/SubViewport/EndOfLevelMessage.text = cleared_text
		$MessageRight/SubViewport/EndOfLevelMessage.text = cleared_text
	else:
		$MessageLeft/SubViewport/EndOfLevelMessage.text = failed_text
		$MessageRight/SubViewport/EndOfLevelMessage.text = failed_text
