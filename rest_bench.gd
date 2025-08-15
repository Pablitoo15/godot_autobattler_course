extends Node2D

var objects_to_move = []
@export var rest_point: Node2D
@export var battlefiled_point: Node2D
@export var button_deploy: Button
@export var button_return: Button
@export var arena_manager: Arena_Manager

func _ready() -> void:
	var area2d = arena_manager.get_node("Area2D")
	button_deploy.connect("pressed", _on_deploy_1_pressed)
	button_return.connect("pressed", _on_return_1_button_down)
	#area2d.connect("body_entered", _on_area_2d_body_entered)
	#area2d.connect("body_exited", _on_area_2d_body_entered)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("unit"):
		body.add_to_group("resting")
		objects_to_move.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("unit"):
		body.remove_from_group("resting")
		objects_to_move.erase(body)

func move_to(to_battlefield: bool):
	var where_to_go: Vector2
	var relative_point: Vector2
	var is_order_for_resting_units: bool
	var array_of_units = []
	if to_battlefield:
		array_of_units = objects_to_move.duplicate()
		where_to_go = battlefiled_point.global_position
		relative_point = rest_point.global_position
		is_order_for_resting_units = true
	else:
		var temp_array = arena_manager.get_array_units()
		array_of_units = temp_array.duplicate()
		where_to_go = rest_point.global_position
		relative_point = battlefiled_point.global_position
		is_order_for_resting_units = false
	for unit in array_of_units:
		if unit and to_battlefield == unit.is_in_group("resting"):
			var offset = unit.global_position - relative_point
			var destination = offset + where_to_go
			unit.set_defend_post(destination)


func _on_deploy_1_pressed() -> void:
	move_to(true)

func _on_return_1_button_down() -> void:
	move_to(false)
