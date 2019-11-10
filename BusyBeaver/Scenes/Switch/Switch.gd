extends Node2D

signal activation_changed(activated)

var is_activated: bool = false

func _on_Area2D_body_entered(body: PhysicsBody2D):
	if !is_activated and body.is_in_group("torch"):
		emit_signal("activation_changed", true)
		is_activated = true


func _on_Area2D_body_exited(body: PhysicsBody2D):
	if is_activated and body.is_in_group("torch"):
		emit_signal("activation_changed", false)
		is_activated = false
