@tool

class_name Cat 
extends CharacterBody3D

@onready var animated_sprite = $AnimatedSprite3D
@onready var base_collision = $BaseCollision
@onready var slide_collision = $SlideCollision
@onready var ceiling_trigger = $CeilingTrigger
@onready var state_machine = $StateMachine
@onready var debug_label = $DebugLabel

@export var cat_path: CatPath:
	set(_cat_path):
		cat_path = _cat_path
		update_configuration_warnings()
		
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

# Hit
@export var hit_jum_velocity: float = 2.0
@export var hit_path_setback: float = 3.0


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if not cat_path:
		warnings.push_back('The cat need a CatPath (for now)')

	return warnings


func _ready():
	if Engine.is_editor_hint():		
		set_process(false)
		set_physics_process(false)
		set_process_input(false)
		set_process_unhandled_input(false)
	else:	
		position = cat_path.get_follow_position()
		floor_constant_speed = true


func _physics_process(_delta):
	
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * _delta

	move_and_slide()
	
	rotation = cat_path.get_follow_rotation()
	rotate_y(deg_to_rad(90))
	
	
func _process(_delta):
	#debug_label.text = str(cat_path.get_progress()
	#debug_label.text = state_machine.state.name
	#debug_label.text = "Ceiling" if ceiling_trigger.has_overlapping_bodies() else "No ceiling"
	#debug_label.text = str(Engine.get_frames_per_second())
	return
	
		
func enable_slide_collision(_enabled: bool):
	base_collision.disabled = _enabled
	slide_collision.disabled = not _enabled
	
	
func update_velocity_to_follow_path(_speed: float, _delta: float):
	var direction = cat_path.get_follow_position() - position
	direction.y = 0.0
	var distanceToPath = direction.length()
		
	cat_path.increment_progress(_speed * _delta)
	direction = cat_path.get_follow_position() - position
	direction.y = 0.0
	distanceToPath = direction.length();
		
			
	direction = direction.normalized()
		
	if direction:
		velocity.x = direction.x * maxf(_speed, distanceToPath)
		velocity.z = direction.z * maxf(_speed, distanceToPath)
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)
		velocity.z = move_toward(velocity.z, 0, _speed)
