extends Node2D

@export var enemy_to_spawn: Array[PackedScene]
@export var enemies_to_spawn_min: int
@export var enemies_to_spawn_max: int
@export var wait_time_between_waves_min: float
@export var wait_time_between_waves_max: float
@export var parent_node: Node2D

@onready var timer_time: float
@onready var timer = $Timer
@onready var sprite = $RichTextLabel

func _ready() -> void:
	setup_timer()


func _on_timer_timeout() -> void:
	spawn_enemies()
	setup_timer()
	
func spawn_enemies():
	var enemy_number: int = randi_range(enemies_to_spawn_min, enemies_to_spawn_max)
	for i in enemy_number:
		var rnd_enemy = enemy_to_spawn.pick_random()
		var enemy = rnd_enemy.instantiate() as CharacterBody2D
		parent_node.add_child(enemy)
		enemy.global_position = sprite.global_position + i * Vector2(10, 0)
	
	if enemies_to_spawn_max > 1:
		enemies_to_spawn_max += 1
		
func setup_timer():
	timer_time = randf_range(wait_time_between_waves_min, wait_time_between_waves_max)
	timer.wait_time = timer_time
	timer.start()
