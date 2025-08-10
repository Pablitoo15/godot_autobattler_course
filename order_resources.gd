extends Node2D

@export var max_resource: int
@export var time_to_reset_resource: float
@export var resource_sprite :Array[Node]

@onready var cur_resource: int = max_resource
@onready var timer: Timer = $resource_timer

func can_make_order():
	if cur_resource > 0:
		return true
	else:
		return false
	
func order_made():
	cur_resource -= 1
	try_start_timer()
	update_visuals()

func update_visuals():
	var i: int
	for sprite: Sprite2D in resource_sprite:
		i += 1

		if cur_resource >= i:
			sprite.visible = true
		else:
			sprite.visible = false
	

func try_start_timer():
	if timer.is_stopped():
		if cur_resource < 3:
			timer.start()
	
func _on_resource_timer_timeout() -> void:
	cur_resource += 1
	clampi(cur_resource, 0, max_resource)
	update_visuals()
	try_start_timer()
