extends Node3D

@export var level: JSON
@export var world_environment: PackedScene
@export var level_number: int
@export var world_number: int
@export var cleared_label: Label
@export var uncleared_label: Label

func _ready() -> void:
	cleared_label.text = str(level_number)
	uncleared_label.text = str(level_number)
	
	if (Main.progress[world_number][level_number]):
		var new_mat = StandardMaterial3D.new()
		new_mat.albedo_color = Color(0,255,0)
		%UpperBase.set_surface_override_material(0, new_mat)
		%UnclearedFlag.visible = false
	else:
		var new_mat = StandardMaterial3D.new()
		new_mat.albedo_color = Color(255,0,0)
		%UpperBase.set_surface_override_material(0, new_mat)
		%ClearedFlag.visible = false
		if (level_number == 1 || !Main.progress[world_number][level_number-1]):
			visible = false

func _on_snap_zone_has_picked_up(what: Variant) -> void:
	Main.selected_level = level.resource_path
	var environment_path = Main.get_world_environment_path(world_number)
	load_level(environment_path)

func _on_snap_zone_has_dropped() -> void:
	Main.selected_level = null

func load_level(path: String) -> void:
	print("Loading level ", world_number, "-", level_number)
	Main.current_world = world_number
	Main.current_level = level_number
	get_tree().change_scene_to_file.bind(path).call_deferred()
