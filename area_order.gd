extends Node2D

var objects: Array[Node]
var objects_to_move = []
var offset_from_center_list: Array[Vector2]
var movement_goal
@export var move_marker: PackedScene

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()

	if Input.is_action_just_pressed("click"):
		var where_clicked = get_global_mouse_position()

		if objects_to_move.size() == 0:
			get_objects(where_clicked)
		else:
			make_order(where_clicked)
	if Input.is_action_just_pressed("cancle"):
		cancle()
		
func cancle():
	objects_to_move.clear()
		
func get_objects(click_pos: Vector2):
	for unit in objects:
		var offset = unit.global_position - click_pos
		objects_to_move.append({"unit": unit, "offset": offset})
		
		

func make_order(click_pos: Vector2):
	var i: int = 0
	for pair in objects_to_move:
		var unit = pair["unit"]
		var offset = pair["offset"]
		
		if unit:
			
			var desitination = click_pos + offset
			if unit.has_method("to_goal"):
				unit.to_goal(desitination)
		i = i + 1

	var created_marker: Node2D = move_marker.instantiate()
	created_marker.global_position = click_pos
	get_parent().add_child(created_marker)
	objects_to_move.clear()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("unit"):
		objects.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("unit"):
		objects.erase(body)
