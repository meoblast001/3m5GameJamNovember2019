extends RigidBody2D

# Declare member variables here. Examples:
export var max_speed = 400 # pixels / sec
export var acc = 50
var screen_size
var jump_timer : float

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.


func _integrate_forces(state):
	jump_timer += state.step
	
	if Input.is_action_pressed("ui_right"):
		if state.linear_velocity.x < max_speed:
			state.apply_central_impulse(Vector2(min(max_speed - state.linear_velocity.x, acc), 0))
	elif Input.is_action_pressed("ui_left"):
		if state.linear_velocity.x > -max_speed:
			state.apply_central_impulse(Vector2(max(-max_speed - state.linear_velocity.x, -acc), 0))
	else:
		if state.linear_velocity.x != 0:
			state.apply_central_impulse(Vector2(-state.linear_velocity.x, 0))
	if jump_timer > 0.5 and Input.is_action_just_pressed("ui_up"):
		jump_timer = 0
		state.apply_central_impulse(Vector2(0, -98))
	
	if state.linear_velocity.length() > 0:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
