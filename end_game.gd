extends Node2D

@export var wave_to_win: int
@onready var progres_bar: ProgressBar = $ProgressBar

var current_wave: int
var arena_mangers = [Arena_Manager]

func _ready() -> void:
	progres_bar.max_value = wave_to_win
	arena_mangers = get_tree().get_nodes_in_group("arena_manager")
	print("that many arena mangers on map: " + str(arena_mangers.size()))
	for arena in arena_mangers:
		arena.connect("wave_beaten", wave_beaten)
	
	
func update_bar():
	progres_bar.value = current_wave
	if current_wave >= wave_to_win:
		get_tree().paused = true

func wave_beaten():
	current_wave += 1
	update_bar()
