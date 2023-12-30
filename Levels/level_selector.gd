extends Node3D

@export var level: JSON
@export var world_environment: PackedScene
@export var level_number: int
@export var cleared_label: Label
@export var uncleared_label: Label

func _ready() -> void:
	cleared_label.text = str(level_number)
	uncleared_label.text = str(level_number)

func _on_snap_zone_has_picked_up(what: Variant) -> void:
	Main.selected_level = level.resource_path

func _on_snap_zone_has_dropped() -> void:
	Main.selected_level = null

func load_level() -> void:
	get_tree().change_scene_to_file.bind(world_environment.resource_path).call_deferred()
