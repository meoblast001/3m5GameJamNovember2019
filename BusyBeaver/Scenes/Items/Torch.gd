extends Item

class_name Torch

signal torch_dropped
signal torch_picked_up

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _on_pickup():
	emit_signal("torch_picked_up", self)
	pass
	
func _ondrop():
	emit_signal("torch_dropped", self)
	pass
