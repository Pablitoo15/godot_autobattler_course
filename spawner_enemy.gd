extends Node2D


@export var enemy_to_spawn: Array[PackedScene]
@export var enemies_to_spawn_min: int
@export var enemies_to_spawn_max: int
@export var wait_time_between_waves_min: float
@export var wait_time_between_waves_max: float
@export var wave_time_waiting: float
@export var parent_node: Node2D

@onready var timer_time: float
@onready var timer = $Timer
@onready var progres_bar = $ProgressBar
@onready var sprite = $RichTextLabel
var timer_cutdown: SceneTreeTimer = null


func _ready() -> void:
	progres_bar.max_value = wave_time_waiting
	setup_timer()
	#temtemtemp!
	await get_tree().create_timer(0.5).timeout
	spawn_enemies()
	

func _process(delta: float) -> void:
	if timer_cutdown != null:
		progres_bar.value = wave_time_waiting - timer_cutdown.time_left
		print(timer_cutdown.time_left)
	else:
		if progres_bar.visible == true:
			return
		else:
			progres_bar.visible = false

func _on_timer_timeout() -> void:
	spawn_enemies()
	setup_timer()
	
func spawn_enemies():
	var enemy_number: int = randi_range(enemies_to_spawn_min, enemies_to_spawn_max)
	var enemy_group = []
	for i in enemy_number:
		var rnd_enemy = enemy_to_spawn.pick_random()
		var wave = rnd_enemy.instantiate()
		parent_node.add_child(wave)
		enemy_group = wave.get_children()

		for enemy_unit in enemy_group:
			enemy_unit.reparent(parent_node)
	
	activate_enemies_with_delay(enemy_group)
	if enemies_to_spawn_max > 1:
		enemies_to_spawn_max += 1
		
func activate_enemies_with_delay(enemy_group: Array):
	timer_cutdown =  get_tree().create_timer(wave_time_waiting)
	await  timer_cutdown.timeout
	timer_cutdown = null
	for enemy_unit in enemy_group:
		enemy_unit.process_mode = Node.PROCESS_MODE_INHERIT

func setup_timer():
	timer_time = randf_range(wait_time_between_waves_min, wait_time_between_waves_max)
	timer.wait_time = timer_time
	timer.start()
