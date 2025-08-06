extends Node2D
class_name  Arena_Manager

@export var team_enemy_tag: String
@export var team_ally_tag: String

var team_ally: Array[Node]
var team_enemy: Array[Node]

@onready var collison_change_teams = $Area2D/CollisionShape2D

func _ready() -> void:
	team_ally = get_tree().get_nodes_in_group(team_ally_tag)
	team_enemy = get_tree().get_nodes_in_group(team_enemy_tag)

func get_closest_enemy(unit: Node2D):
	var closest: Node2D = null
	var closes_yet:= INF
	var team_to_find
	
	if unit.is_in_group(team_ally_tag):
		team_to_find = team_enemy
	else:
		team_to_find = team_ally
	
	for possible_target in team_to_find:
		var dist = unit.global_position.distance_to(possible_target.global_position)
		if dist < closes_yet:
			closes_yet = dist
			closest = possible_target
	
	return closest

func unit_die(unit: Node2D):
	if unit.is_in_group(team_ally_tag):
		team_ally.erase(unit)
	else:
		team_enemy.erase(unit)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("new_parent_arena") and body.is_moving():
		print("sthsth")
		body.new_parent_arena(self)
		var group = body.get_groups()
		var one_group = group[0]
		body.remove_from_group(one_group)
		body.add_to_group(team_ally_tag)
		team_ally.append(body)
