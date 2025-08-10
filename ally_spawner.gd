extends Node2D

@export var icon: Sprite2D
@export var unit: PackedScene
@export var time_to_spawn: int
@export var where_to_spawn: Node2D

@onready var timer: Timer = $Timer
@onready var progres_bar: ProgressBar = $ProgressBar

var outline_shader = preload("res://assets/shaders/2d_outline_shader.tres")
var order_resource

func _ready() -> void:
	timer.wait_time = time_to_spawn
	order_resource = get_tree().get_first_node_in_group("order_resource")

func spawn_unit():
	var spawned_unit: CharacterBody2D = unit.instantiate()
	spawned_unit.global_position = global_position
	where_to_spawn.add_child(spawned_unit)

func on_clicked():
	timer.start()

func _process(delta: float) -> void:
	if not timer.is_stopped():
		if progres_bar.visible == false:
			progres_bar.visible = true
		var time_left =  (time_to_spawn - timer.time_left)/time_to_spawn
		progres_bar.value = time_left
	
	elif progres_bar.visible == true:
		progres_bar.visible = false

func _on_timer_timeout() -> void:
	spawn_unit()


func _on_button_pressed() -> void:
	if timer.is_stopped():
		on_clicked()
		if order_resource:
			if order_resource.can_make_order():
				order_resource.order_made()
