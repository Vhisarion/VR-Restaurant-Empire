extends Node3D

signal on_button_pressed()


func _on_interactable_area_button_button_pressed(button: Variant) -> void:
	on_button_pressed.emit()
