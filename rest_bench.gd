extends Node2D




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("unit"):
		body.add_to_group("resting")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("unit"):
		body.remove_from_group("resting")
