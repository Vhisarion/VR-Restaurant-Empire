extends Node3D

var xr_interface: XRInterface

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
		
		get_tree().change_scene_to_file("res://Levels/Stage_1/Testing_Level.tscn")
	else:
		print("OpenXR not initialized, please check if your headset is connected")
