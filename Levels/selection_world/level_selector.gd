extends Node3D

@export var level: JSON
@export var world_environment: PackedScene
@export var level_number: int
@export var world_number: int
@export var cleared_label: Label
@export var uncleared_label: Label
@export var player: XROrigin3D

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
		if (level_number != 1 && !Main.progress[world_number][level_number-1]):
			visible = false
			$SnapZone.enabled = false

func _on_snap_zone_has_picked_up(what: Variant) -> void:
	Main.selected_level = level.resource_path
	Main.current_world = world_number
	Main.current_level = level_number
	player.transition()

func _on_snap_zone_has_dropped() -> void:
	Main.selected_level = null

func _on_player_transitioned() -> void:
	var environment_path = Main.get_world_environment_path(world_number)
	get_tree().change_scene_to_file(environment_path)
