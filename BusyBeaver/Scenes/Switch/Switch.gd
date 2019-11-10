extends Node2D

signal activation_changed(activated)

var num_activation_attempts: int = 0

func _on_Area2D_body_entered(body: PhysicsBody2D):
	if body.is_in_group("torch"):
		if num_activation_attempts == 0:
			emit_signal("activation_changed", true)
		num_activation_attempts += 1


func _on_Area2D_body_exited(body: PhysicsBody2D):
	if body.is_in_group("torch"):
		num_activation_attempts -= 1
		if num_activation_attempts == 0:
			emit_signal("activation_changed", false)
