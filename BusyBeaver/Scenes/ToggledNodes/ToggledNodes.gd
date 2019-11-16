extends Node

export var disabled_on_ready = false;
export var negate_activation = false;

var disabled_nodes = []

func _ready():
	if disabled_on_ready:
		_toggle_nodes(false)

func _toggle_nodes(activated: bool):
	if activated if negate_activation else !activated:
		for node in $Subjects.get_children():
			$Subjects.remove_child(node)
			disabled_nodes.append(node)
	else:
		for node in disabled_nodes:
			$Subjects.add_child(node)
		disabled_nodes.clear()
