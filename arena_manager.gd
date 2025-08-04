extends Node2D

var team_ally: Array[Node]
var team_enemy: Array[Node]

func _ready() -> void:
	team_ally = get_tree().get_nodes_in_group("team_ally")
	team_enemy = get_tree().get_nodes_in_group("team_enemy")
	print(team_ally.size())
	print(team_enemy.size())

func get_closest_enemy(unit: Node2D):
	var closest: Node2D = null
	var closes_yet:= INF
	var team_to_find
	
	if unit.is_in_group("team_ally"):
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
	if unit.is_in_group("team_ally"):
		team_ally.erase(unit)
	else:
		team_enemy.erase(unit)
