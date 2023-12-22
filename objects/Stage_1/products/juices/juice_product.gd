class_name JuiceProduct

extends Product

enum StrawType {NO_STRAW, RED_STRAW, BLUE_STRAW}

@export var straw_type: StrawType

func _ready():
	super._ready()
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
	if (%RedStraw != null):
		%RedStraw.visible = false
	if (%BlueStraw != null):
		%BlueStraw.visible = false

func _show_straw():
	if (%RedStraw != null):
		%RedStraw.visible = true
	if (%BlueStraw != null):
		%BlueStraw.visible = true

func _change_straw_color(type: StrawType):
	if (%RedStraw == null || %BlueStraw == null):
		return
	
	# Change straw color to the corresponding type
	match type:
		StrawType.RED_STRAW:
			%RedStraw.visible = true
			%BlueStraw.visible = false
		StrawType.BLUE_STRAW:
			%RedStraw.visible = false
			%BlueStraw.visible = true
		_:
			# No straw or unknown straw -> hide the straw.
			print("Uknown straw, hiding the straw")
			_hide_straw()

func equals(other) -> bool:
	return (other is JuiceProduct) && straw_type == other.straw_type

func get_instance(cls := "") -> Node:
	var instance = super.get_instance(cls)
	instance.set_straw(straw_type)
	return instance
