extends XROrigin3D

signal transitioned()

func _ready() -> void:
	%TransitionAnimation.play("fade_to_normal")

func transition() -> void:
	%TransitionAnimation.play("fade_to_black")

func _on_transition_animation_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "fade_to_black"):
		transitioned.emit()

func get_transition_animation() -> AnimationPlayer:
	return %TransitionAnimation
