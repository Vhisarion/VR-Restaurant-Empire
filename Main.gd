extends Node3D

var xr_interface: XRInterface

var current_level: int
var current_world: int
var selected_level = "res://levels/stage_1/level_5.json"
@export var world_environments: Array[PackedScene]

# world and level progress matrix
var progress
var save_path = "user://progress.save"

func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialised successfully")

		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		# Prevent wonky 60fps physics
		Engine.physics_ticks_per_second = 120

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
		
		# Connect to transition screen
		TransitionScreen.transitioned.connect(_on_transitioned)
		
		# Load saved data
		DirAccess.remove_absolute(save_path)
		load_progress()
		
		# Load Level Selector
		get_tree().change_scene_to_file.bind("res://levels/selection_world.tscn").call_deferred()
	else:
		print("OpenXR not initialized, please check if your headset is connected")

func save_progress() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(progress)
	print("Saved progress: ", progress)

func load_progress() -> void:
	if (FileAccess.file_exists(save_path)):
		var file = FileAccess.open(save_path, FileAccess.READ)
		progress = file.get_var(true)
		print("Loaded progress: ", progress)
	else:
		# Create progress array
		var arr: Array[Array] = []
		arr.resize(world_environments.size())
		var world_arr = []
		world_arr.resize(100)
		world_arr.fill(false)
		for index in range(world_environments.size()):
			arr[index] = world_arr.duplicate()
		progress = arr

func get_world_environment_path(world_number: int) -> String:
	return world_environments[world_number].resource_path

func complete_current_level() -> void:
	progress[current_world][current_level] = true
	save_progress()

func return_to_level_selection() -> void:
	current_world = 0
	current_level = 0

func load_selection_world() -> void:
	get_tree().change_scene_to_packed.bind(world_environments[0]).call_deferred()

func _on_transitioned() -> void:
	load_selection_world()
