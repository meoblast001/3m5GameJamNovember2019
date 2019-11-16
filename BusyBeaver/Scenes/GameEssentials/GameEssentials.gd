extends Node2D

func _ready():
	var goals = get_tree().get_nodes_in_group("goal")
	for goal in goals:
		(goal as Node).connect("goal_reached", self, "_on_win")
		
func _on_win():
	get_tree().quit()