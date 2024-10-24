class_name Cat

extends CharacterBody3D

enum CatMotionState {IDLE, RUNNING, JUMPING, SLIDING}

@onready var animated_sprite = $AnimatedSprite3D
@onready var base_collision = $BaseCollision
@onready var slide_collision = $SlideCollision
@onready var ceiling_trigger = $CeilingTrigger

@onready var debug_label = $DebugLabel

@export var cat_path: CatPath
@export var lost_path_distance: float = 1.5

@export var speed: 	float = 5.0

var motion_state: CatMotionState = CatMotionState.IDLE

# Jump
@export var max_jump_time: 				float = 0.6
@export var initial_jump_velocity: 		float = 3.5
@export var continuous_jum_velocity: 	float = 5.0
var jump_time: float = 0.0

# Slide
@export var slide_speed:	float = 5.0
@export var min_slide_time:	float = 0.5
@export var max_slide_time:	float = 1.0
var slide_time: float = 0.0


var started = false

func _ready():
	position = cat_path.path_follow.position
	floor_constant_speed = true
	
func _input(event):
	if event.is_action_pressed("Confirm"):
		started = true
		motion_state = CatMotionState.RUNNING


func _physics_process(delta):
	
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if started == true:

		# Handle jump.
		if motion_state != CatMotionState.JUMPING and Input.is_action_just_pressed("Jump") and is_on_floor():
			motion_state = CatMotionState.JUMPING
			velocity.y = initial_jump_velocity
		elif motion_state == CatMotionState.JUMPING and jump_time < max_jump_time and Input.is_action_pressed("Jump"):
			velocity.y += continuous_jum_velocity * delta
			jump_time+= delta
		elif motion_state == CatMotionState.RUNNING and Input.is_action_just_pressed("Slide") and is_on_floor():
			motion_state = CatMotionState.SLIDING
			enable_slide_collision(true)
		elif motion_state == CatMotionState.SLIDING and (slide_time < max_slide_time and (Input.is_action_pressed("Slide") or slide_time < min_slide_time) or ceiling_trigger.has_overlapping_bodies()):
			slide_time += delta
		else:
			motion_state = CatMotionState.RUNNING
			enable_slide_collision(false)
			jump_time = 0.0
			slide_time = 0.0
		
		# Follow path
		var direction = cat_path.path_follow.position - position
		direction.y = 0.0
		var distanceToPath = direction.length()
		
		var current_speed
		match motion_state:
			CatMotionState.SLIDING:
				current_speed = slide_speed
			_:
				current_speed = speed 
		
		if distanceToPath < lost_path_distance:
			cat_path.path_follow.progress += current_speed * delta
			direction = cat_path.path_follow.position - position
			direction.y = 0.0
			distanceToPath = direction.length();
		
		if distanceToPath < 0.05:
			direction *= 0.0
			
		direction = direction.normalized()
		
		if direction:
			velocity.x = direction.x * maxf(current_speed, distanceToPath)
			velocity.z = direction.z * maxf(current_speed, distanceToPath)
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed)
			velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
	
	rotation = cat_path.path_follow.rotation
	rotate_y(deg_to_rad(90))
	

func _process(delta):
	
	#debug_label.text = CatMotionState.keys()[motion_state]
	#debug_label.text = "Ceiling" if ceiling_trigger.has_overlapping_bodies() else "No ceiling"
	
	if is_on_wall():
		animated_sprite.play("Hit")
	elif not is_on_floor():
		if motion_state == CatMotionState.JUMPING and jump_time == 0.0:
			animated_sprite.play("Jump")
		elif velocity.y < 0.0:
			animated_sprite.play("Fall")
	elif motion_state == CatMotionState.SLIDING:
		animated_sprite.play("Slide")
	elif velocity.x != 0.0 or velocity.z != 0.0:
		animated_sprite.play("Run")
	else:
		animated_sprite.play("Stand_Idle")
		motion_state = CatMotionState.IDLE
		
func enable_slide_collision(enabled: bool):
	base_collision.disabled = enabled
	slide_collision.disabled = not enabled
