extends Sprite

signal goal_reached()

func _on_Area2D_body_entered(body):
	if (body as Node).is_in_group("player"):
		emit_signal("goal_reached")
