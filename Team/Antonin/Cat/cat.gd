class_name Cat extends CharacterBody3D

@onready var animated_sprite = $AnimatedSprite3D
@onready var base_collision = $BaseCollision
@onready var slide_collision = $SlideCollision
@onready var ceiling_trigger = $CeilingTrigger
@onready var state_machine = $StateMachine
@onready var debug_label = $DebugLabel

@export var cat_path: CatPath
@export var lost_path_distance: float = 1.5

@export var speed: 	float = 5.0


# Jump
@export var max_jump_time: 				float = 0.6
@export var initial_jump_velocity: 		float = 3.5
@export var continuous_jump_velocity: 	float = 5.0

# Slide
@export var slide_speed:	float = 5.0
@export var min_slide_time:	float = 0.5
@export var max_slide_time:	float = 1.0


func _ready():
	position = cat_path.path_follow.position
	floor_constant_speed = true


func _physics_process(delta):
	
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
	
	rotation = cat_path.path_follow.rotation
	rotate_y(deg_to_rad(90))
	
	
#func _process(delta):
	#debug_label.text = state_machine.state.name
	#debug_label.text = "Ceiling" if ceiling_trigger.has_overlapping_bodies() else "No ceiling"
	
		
func enable_slide_collision(enabled: bool):
	base_collision.disabled = enabled
	slide_collision.disabled = not enabled
	
	
func update_velocity_to_follow_path(speed: float, delta: float):
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
