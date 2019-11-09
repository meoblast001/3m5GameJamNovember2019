extends KinematicBody2D

# Declare member variables here. Examples:
export var GRAVITY = 200.0
export var SPEED = 400 # pixels / sec
export var JUMP_HEIGHT = 400
var screen_size
var jump_counter = 0
var walkAnimationPlaying : bool

var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.

func handleGravity(delta):
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y += delta * GRAVITY

func handleJump():
	if is_on_floor():
		jump_counter = 0
	
	if jump_counter < 2 and Input.is_action_just_pressed("ui_up"):
		jump_counter += 1
		
		# maybe we should add jump height instead of setting it?
		velocity.y = -JUMP_HEIGHT
		if jump_counter == 1:
			$AnimationPlayer.play("Jump")
		else:
			$AnimationPlayer.play("Double Jump")
		
func handleWalkInput():
	if Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
	else:
		velocity.x = 0

func handleWalkAnimation():
	if velocity.x != 0:
		$Sprite.flip_h = velocity.x < 0
		
		# that is: if no other animation is playing
		if not $AnimationPlayer.is_playing():
			walkAnimationPlaying = true
			$AnimationPlayer.play("Walk")
	else:
		if walkAnimationPlaying:
			walkAnimationPlaying = false
			$AnimationPlayer.seek(0, true)
			$AnimationPlayer.stop()
	

func _physics_process(delta):
	handleGravity(delta)
	handleWalkInput()
	handleJump()
	
	handleWalkAnimation()
		
	# The second parameter of move_and_slide is the normal pointing up.
	# In the case of a 2d platformer, in Godot upward is negative y, which translates to -1 as a normal.
	move_and_slide(velocity, Vector2(0, -1))