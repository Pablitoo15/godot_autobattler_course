extends Node2D

var objects_to_move = []
var what_and_where = []
var offset_from_center_list: Array[Vector2]
@export var rest_point: Node2D
@export var battlefiled_point: Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("unit"):
		body.add_to_group("resting")
		objects_to_move.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("unit"):
		body.remove_from_group("resting")

func move_to(to_battlefield: bool):
	var where_to_go: Vector2
	var relative_point: Vector2
	if to_battlefield:
		where_to_go = battlefiled_point.global_position
		relative_point = rest_point.global_position
	else:
		where_to_go = rest_point.global_position
		relative_point = battlefiled_point.global_position
	
	for unit in objects_to_move:
		if unit:
			var offset = unit.global_position - relative_point
			var destination = offset + where_to_go
			unit.set_defend_post(destination)


func _on_deploy_1_pressed() -> void:
	move_to(true)

func _on_return_1_button_down() -> void:
	move_to(false)
