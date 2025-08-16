extends CharacterBody2D

var outline_shader: ShaderMaterial = preload("res://assets/shaders/2d_outline_shader.tres")
@export var max_health: float
@export var speed: float
@export var damage: float
@export var team: int
@export var attack_interval: float

@onready var progres_bar = $"2d/ProgressBar"
@onready var collision =$"2d/Area2D/CollisionShape2D"
@onready var sprite = $"2d/Sprite2D"
enum State {walk_to_target, attack_target, only_move, idle, defending_pos}
var cur_state = State.idle
var cur_health: float
var cur_target: Node2D
var cur_move_to: Vector2
var defend_pos: Vector2
var range: float
var arena_manager
var wait_before_attack



func _ready() -> void:
	cur_health = max_health
	range = collision.shape.radius / 4
	wait_before_attack = attack_interval
	set_progres_bar()
	

	#
func _process(delta: float) -> void:
	#Nasty hack which I don't like or support
	if self.is_in_group("enemy") or self.is_in_group("base") and arena_manager == null:
		arena_manager = get_parent()
		arena_manager.add_to_list(self)
	#if cur_state == State.idle:
		#return
		
	if cur_state == State.only_move:
		move_to(cur_move_to, delta)


	elif cur_state == State.defending_pos:
		move_to(defend_pos, delta)
	
	elif cur_state == State.walk_to_target:
		if cur_target != null:
			move_to(cur_target.global_position, delta)


		else:
			pass
			
	elif cur_state == State.attack_target:
			attack(delta)
	
	elif cur_state == State.idle:
		pass
	evalute_state()

func evalute_state():
	var defend_pos_bool:bool = defend_pos != Vector2.ZERO and not global_position.distance_to(defend_pos) < 10
	if global_position.distance_to(cur_move_to) < 10:
		cur_move_to = Vector2.ZERO
	
	if cur_move_to != Vector2(0, 0):
		cur_state = State.only_move
		return
	
	elif defend_pos:
		if arena_manager:
			cur_target = arena_manager.get_closest_enemy(self)
			if check_if_range():
				cur_state = State.attack_target
			elif cur_target:
				cur_state = State.walk_to_target
			else:
				cur_state = State.defending_pos

		else:
			cur_state = State.defending_pos


	elif self.is_in_group("resting"):
		cur_state = State.idle
		return
			
	elif check_if_range():
		cur_state = State.attack_target
		return
		
	else:
		if arena_manager:
			cur_target = arena_manager.get_closest_enemy(self)
			
		if cur_target != null:
			cur_state = State.walk_to_target
			return
		
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
		wait_before_attack = attack_interval
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

func move_to(goal: Vector2, delta: float):
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
	print("new arena manager")
	if arena_manager:
		arena_manager.unit_die(self)
	arena_manager = new_arena_manger
	
func is_moving():
	if cur_move_to != Vector2(0, 0):
		return true
	else:
		return false
		
func to_goal(destination: Vector2):
	cur_move_to = destination

func turn_on_shader(is_true: bool):
	if is_true:
		sprite.material = outline_shader
	else:
		sprite.material = null

func set_defend_post(new_defened_pos: Vector2):
	if defend_pos != new_defened_pos:
		print("new defend point!")
	defend_pos =  new_defened_pos
	
	
