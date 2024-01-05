extends Node3D

func _on_button_pedestal_on_button_pressed() -> void:
	get_tree().create_timer(1).timeout.connect(on_timeout)

func on_timeout() -> void:
	get_tree().quit()
