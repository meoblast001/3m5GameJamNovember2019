extends KinematicBody2D

# Declare member variables here. Examples:
export var GRAVITY = 200.0
export var SPEED = 400 # pixels / sec
export var JUMP_HEIGHT = 400
export var IN_AIR_DELAY = 0.2
export var MAX_JUMP_COUNT = 2
var screen_size
var jump_counter = 0
var in_air_timer : float
var walkAnimationPlaying : bool
var last_wall = 'none'
var last_jumped_wall = 'none'
var is_wall_jump : bool

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

func handleJump(delta):
	in_air_timer += delta
	
	if is_on_floor():
		jump_counter = 0
		in_air_timer = 0
		last_jumped_wall = 'none'
		last_wall = 'none'
		is_wall_jump = false
	
	elif in_air_timer > IN_AIR_DELAY and is_on_wall():
		var collision = get_slide_collision(0)
		var current_wall = 'left' if collision.position.x < position.x else 'right'
		
		print(current_wall, last_jumped_wall)
		
		if current_wall != last_jumped_wall:
			jump_counter = 0
			in_air_timer = 0
		
		is_wall_jump = true
		last_wall = current_wall
	
	if in_air_timer > IN_AIR_DELAY:
		jump_counter = max(jump_counter, 1)
		
	
	if jump_counter < MAX_JUMP_COUNT and Input.is_action_just_pressed("ui_up"):
		jump_counter += 1
		
		# maybe we should add jump height instead of setting it?
		velocity.y = -JUMP_HEIGHT
		if jump_counter == 1:
			if is_wall_jump:
				last_jumped_wall = last_wall
			
			walkAnimationPlaying = false
			$AnimationPlayer.play("Jump")
		else:
			walkAnimationPlaying = false
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
	handleJump(delta)
	
	handleWalkAnimation()
		
	# The second parameter of move_and_slide is the normal pointing up.
	# In the case of a 2d platformer, in Godot upward is negative y, which translates to -1 as a normal.
	move_and_slide(velocity, Vector2(0, -1))
