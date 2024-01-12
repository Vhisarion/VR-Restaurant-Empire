@tool
class_name TutorialTablet
extends XRToolsPickable

@export var viewport: SubViewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	RenderingServer.frame_post_draw.connect(on_draw.bind())
	
	
func on_draw() -> void:
	if (viewport != null):
		var tex = viewport.get_texture()
		%Sprite3D.texture = tex
		RenderingServer.frame_post_draw.disconnect(on_draw.bind())
