extends NavigationRegion2D

func _on_red_castle_destroyed() -> void:
	await get_tree().physics_frame
	bake_navigation_polygon()
