extends Item

class_name Chainsaw

signal chainsaw_dropped
signal chainsaw_picked_up

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../ItemManager".wire_chainsaw(self)
	emit_signal("spawned", self)
	pass # Replace with function body.

func _on_pickup():
	emit_signal("chainsaw_picked_up", self)
	pass

func _ondrop():
	emit_signal("chainsaw_dropped", self)
	pass
