class_name Cat

extends CharacterBody3D

@export var cat_path: CatPath

@export var speed: 	float = 5.0

@export var lost_path_distance: float = 1.5

@export var max_jump_time: 				float = 0.6
@export var initial_jump_velocity: 		float = 3.5
@export var continuous_jum_velocity: 	float = 5.0
var is_jumping: 	bool = false;
var jump_time:       float = 0.0

@onready var animated_sprite = $AnimatedSprite3D

var started = false

func _ready():
	position = cat_path.path_follow.position
	floor_constant_speed = true
	
func _input(event):
	if event.is_action_pressed("Confirm"):
		started = true


func _physics_process(delta):
	
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if started == true:

		# Handle jump.
		if Input.is_action_just_pressed("Jump") and is_on_floor() and not is_jumping:
			is_jumping = true
			velocity.y = initial_jump_velocity
		elif Input.is_action_pressed("Jump") and is_jumping and jump_time < max_jump_time:
			velocity.y += continuous_jum_velocity * delta
			jump_time+= delta
		else:
			is_jumping = false
			jump_time = 0.0

		
		# Follow path
		var direction = cat_path.path_follow.position - position
		direction.y = 0.0
		var distanceToPath = direction.length()
		
		if distanceToPath < lost_path_distance:
			cat_path.path_follow.progress += speed * delta
			direction = cat_path.path_follow.position - position
			direction.y = 0.0
			distanceToPath = direction.length();
		
		if distanceToPath < 0.05:
			direction *= 0.0
			
		direction = direction.normalized()
		
		if direction:
			velocity.x = direction.x * maxf(speed, distanceToPath)
			velocity.z = direction.z * maxf(speed, distanceToPath)
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	
	rotation = cat_path.path_follow.rotation
	rotate_y(deg_to_rad(90))
	

func _process(delta):
	
	if is_on_wall():
		animated_sprite.play("Hit")
	elif not is_on_floor():
		if is_jumping and jump_time == 0.0:
			animated_sprite.play("Jump")
		elif velocity.y < 0.0:
			animated_sprite.play("Fall")
	elif velocity.x != 0.0 or velocity.z != 0.0:
		animated_sprite.play("Run")
	else:
		animated_sprite.play("Stand_Idle")
