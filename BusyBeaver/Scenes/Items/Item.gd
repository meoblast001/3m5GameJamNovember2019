extends RigidBody2D

signal spawned

class_name Item

# Declare member variables here.
var collision_timeout = false

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("spawned", self)

func _on_pickup():
	pass

func _on_drop():
	pass
	
func _on_PlayerCollisionArea_body_entered(body):
	if body is KinematicBody2D and collision_timeout == false:
		_on_pickup()
		
func _on_PlayerCollisionArea_body_exited(body):
	if body is KinematicBody2D:
		collision_timeout = false
		
func set_collision_timeout():
	collision_timeout = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
