extends Node2D

@export var units_to_defend: Array[CharacterBody2D]
@export var canvas: CanvasModulate


func _ready() -> void:
	for unit_to_defend in units_to_defend:
		unit_to_defend.connect("tree_exited", on_tree_left)
		
	Engine.time_scale = 0.75
	

func on_tree_left():
	print("end game")
	end_game_screen()

func end_game_screen():
	canvas.visible = true
	#await get_tree().create_timer(1).timeout
	get_tree().paused = true
