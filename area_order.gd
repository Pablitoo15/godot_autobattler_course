extends Node2D

var objects: Array[Node]
var objects_to_move: Array[Node]
var movement_goal

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	

	if Input.is_action_just_pressed("click"):
		if objects_to_move.size() == 0:
			get_objects()
		else:
			make_order()
	if Input.is_action_just_pressed("cancle"):
		cancle()
	print(Engine.get_frames_per_second())
		
func cancle():
	objects_to_move.clear()
		
func get_objects():
	objects_to_move = objects.duplicate()
	print(str(objects_to_move.size()) + " - how many units")

func make_order():
	movement_goal = get_global_mouse_position()
	for unit in objects_to_move:
		unit.to_goal(movement_goal)
	print("movement order for unit was made")
	print(objects_to_move[0].cur_state)
	objects_to_move.clear()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("unit"):
		objects.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("unit"):
		objects.erase(body)
