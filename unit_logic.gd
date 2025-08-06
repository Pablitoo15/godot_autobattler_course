extends CharacterBody2D

@export var max_health: float
@export var speed: float
@export var damage: float
@export var team: int


@onready var progres_bar = $"2d/ProgressBar"
@onready var collision =$"2d/Area2D/CollisionShape2D"
enum State {walk_to_target, attack_target, only_move, idle}
var cur_state = State.idle
var cur_health: float
var cur_target: Node2D
var cur_move_to: Vector2
var range: float
var arena_manager
var max_wait_before_attack: int = 1
var wait_before_attack



func _ready() -> void:
	arena_manager = get_parent()
	cur_health = max_health
	range = collision.shape.radius / 4
	wait_before_attack = max_wait_before_attack
	set_progres_bar()
	
func _process(delta: float) -> void:
	if cur_state == State.only_move:
		move_to(cur_move_to)
	
	if cur_state == State.walk_to_target:
		if cur_target != null:
			move_to(cur_target.global_position)
		else:
			pass
			
	elif cur_state == State.attack_target:
			attack(delta)
	
	elif cur_state == State.idle:
		pass
	evalute_state()
	
func evalute_state():
	if cur_move_to != Vector2(0, 0):
		if cur_state != State.only_move:
			cur_state = State.only_move
			return
	if check_if_range():
		cur_state = State.attack_target
		return
		
	cur_target = arena_manager.get_closest_enemy(self)
	cur_state = State.walk_to_target
		
	if cur_target == null:
		cur_state = State.idle

func check_if_range():
	if cur_target == null:
		return false
	if global_position.distance_to(cur_target.global_position) < range:
		return true

func attack(delta: float):
	wait_before_attack -= delta
	if wait_before_attack <= 0:
		wait_before_attack = max_wait_before_attack
		try_deal_dmg()

		
func try_deal_dmg():
	if cur_target != null:
		cur_target.apply_damage(damage)
	
func apply_damage(get_damaged: float):
	cur_health = cur_health - get_damaged
	update_progres_bar()
	if cur_health <= 0:
		arena_manager.unit_die(self)
		queue_free()

func move_to(goal: Vector2):
	var dir_to_target = (goal - global_position).normalized()
	var move_value = dir_to_target * speed
	velocity = move_value
	move_and_slide()

func update_progres_bar():
	progres_bar.value = cur_health
	if progres_bar.visible == false:
		progres_bar.visible = true
	
func set_progres_bar():
	progres_bar.max_value = max_health
	progres_bar.value = max_health
	
	
func new_parent_arena(new_arena_manger: Arena_Manager):
	arena_manager.unit_die(self)
	arena_manager = new_arena_manger
	
func is_moving():
	if cur_move_to != Vector2(0, 0):
		return true
	else:
		return false
