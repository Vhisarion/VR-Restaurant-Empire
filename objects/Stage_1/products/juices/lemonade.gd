class_name Lemonade

extends JuiceProduct

func equals(other) -> bool:
	return super.equals(other) && (other is Lemonade)

func get_instance(_cls := "") -> Node:
	return super.get_instance("Lemonade") as Lemonade

func _on_straw_snap_zone_has_picked_up(straw):
	set_straw_from_pickable(straw)
	straw.queue_free()
	# Only allow one straw. Delete SnapZone afterwards
	$StrawSnapZone.queue_free()
	var particles_copy = $VFX/LemonParticles.duplicate()
	particles_copy.global_transform = $VFX/LemonParticles.global_transform
	get_tree().current_scene.add_child(particles_copy)
	particles_copy.emitting = true
