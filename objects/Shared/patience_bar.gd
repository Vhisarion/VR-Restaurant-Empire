extends ProgressBar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (value < 30):
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = Color(255,0,0)
		add_theme_stylebox_override("fill", style_box)
	elif (value < 50):
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = Color(255,255,0)
		add_theme_stylebox_override("fill", style_box)
