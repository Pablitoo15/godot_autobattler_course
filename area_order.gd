extends Node2D

var objects: Array[Node]
var objects_to_move: Array[Node]
var movement_goal

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	

	if Input.is_action_just_pressed("click"):
		if objects_to_move.size() == 0:
			get_objects()
			print("marked objects to move")
		else:
			make_order()
			print("give order")
	if Input.is_action_just_pressed("cancle"):
		cancle()
		
func cancle():
	objects_to_move.clear()
		
func get_objects():
	objects_to_move = objects.duplicate()

func make_order():
	movement_goal = get_global_mouse_position()
	for unit in objects_to_move:
		unit.to_goal(movement_goal)
	objects_to_move.clear()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("unit"):
		print("new objects enterd")
		objects.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("unit"):
		objects.erase(body)
