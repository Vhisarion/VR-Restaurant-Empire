class_name JuiceProduct

extends Product

enum StrawType {NO_STRAW, RED_STRAW, BLUE_STRAW}

@export var straw_type: StrawType

func _ready():
	if (straw_type != StrawType.NO_STRAW):
		_show_straw()
		_change_straw_color(straw_type)
	else:
		_hide_straw()

func set_straw(type: StrawType):
	if (type == StrawType.NO_STRAW):
		_hide_straw()
	else:
		# Assert straw is visible
		_change_straw_color(type)
		_show_straw()
	
	straw_type = type

func set_straw_from_pickable(pickable):
	if (pickable is RedStraw):
		set_straw(StrawType.RED_STRAW)
	elif (pickable is BlueStraw):
		set_straw(StrawType.BLUE_STRAW)
	else:
		push_error("Added an unknown straw! Not implemented!")

func _hide_straw():
	if (has_node("Straw")):
		$Straw.visible = false

func _show_straw():
	if (has_node("Straw")):
		$Straw.visible = true

func _change_straw_color(type: StrawType):
	var hasnode = has_node("Straw")
	if (!has_node("Straw")):
		return
	
	# Change straw color to the corresponding type
	match type:
		StrawType.RED_STRAW:
			print("Changing color to red")
			var strawMesh = $Straw.mesh
			$Straw.mesh.material.albedo_color = Color(255,0,0,0,)
		StrawType.BLUE_STRAW:
			print("Changing color to blue")
			$Straw.mesh.material.albedo_color = Color(0,0,255,0,)
		_:
			# No straw or unknown straw -> hide the straw.
			print("Uknown straw, hiding the straw")
			_hide_straw()

func equals(other) -> bool:
	return (other is JuiceProduct) && straw_type == other.straw_type
