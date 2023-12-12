class_name JuiceProduct

extends Product

enum StrawType {NO_STRAW, RED_STRAW, BLUE_STRAW}

var strawType: StrawType

func set_straw(type: StrawType):
	if (type == StrawType.NO_STRAW):
		_hide_straw()
		pass
	
	# Assert straw is visible
	_show_straw()
	
	# Change straw color to the corresponding type
	match type:
		StrawType.RED_STRAW:
			print("Changing color to red")
			$Straw.get_meshes()[1].material.albedo_color = Color(255,0,0,0,)
		StrawType.BLUE_STRAW:
			print("Changing color to blue")
			$Straw.get_meshes()[1].material.albedo_color = Color(0,0,255,0,)
		_:
			# No straw or unknown straw -> hide the straw.
			print("Uknown straw, hiding the straw")
			_hide_straw()
	

func _hide_straw():
	$Straw.visible = false

func _show_straw():
	$Straw.visible = true

func equals(other: Lemonade):
	return self.strawType == other.strawType
