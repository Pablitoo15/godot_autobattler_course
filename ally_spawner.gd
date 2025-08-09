extends Node2D

@export var icon: Sprite2D
@export var unit: PackedScene
@export var time_to_spawn: int

@onready var timer: Timer = $Timer
@onready var progres_bar: ProgressBar = $ProgressBar

var outline_shader = preload("res://assets/shaders/2d_outline_shader.tres")

func _ready() -> void:
	timer.wait_time = time_to_spawn
	print(timer.wait_time)

func spawn_unit():
	var spawned_unit: CharacterBody2D = unit.instantiate()
	spawned_unit.global_position = global_position
	get_parent().add_child(spawned_unit)

func on_clicked():
	timer.start()

func _process(delta: float) -> void:
	progres_bar.value = timer.time_left/time_to_spawn

func _on_timer_timeout() -> void:
	print("done!")
	spawn_unit()


func _on_button_pressed() -> void:
	on_clicked()
