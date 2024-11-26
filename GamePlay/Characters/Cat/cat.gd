@tool

class_name Cat 
extends CharacterBody3D

@onready var animated_sprite = $AnimatedSprite3D
@onready var base_collision = $BaseCollision
@onready var slide_collision = $SlideCollision
@onready var ceiling_trigger = $CeilingTrigger
@onready var state_machine = $StateMachine

@export var cat_path: CatPath:
	set(_cat_path):
		cat_path = _cat_path
		update_configuration_warnings()
		
@export var lost_path_distance: float = 0.1

@export var speed: 	float = 5.0


# Jump
@export var can_jump: 					bool = true
@export var max_jump_time: 				float = 0.6
@export var initial_jump_velocity: 		float = 3.5
@export var continuous_jump_velocity: 	float = 5.0

# Slide
@export var can_slide: 		bool = true
@export var slide_speed:	float = 5.0
@export var min_slide_time:	float = 0.5
@export var max_slide_time:	float = 1.0

# Hit
@export var hit_jum_velocity: float = 2.0
@export var hit_path_setback: float = 3.0

# Touch Screen
var is_screen_touch: bool = false


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
		DebugManager.add_object_to_display(self, "ToggleDebugCat")
		
		
func _input(event):
	var touch_event := event as InputEventScreenTouch
	if touch_event:
		if touch_event.pressed:
			is_screen_touch = true
		else:
			is_screen_touch = false
		
		
func _exit_tree():
	if not Engine.is_editor_hint():
		DebugManager.remove_object_to_display(self)


func _physics_process(_delta):
	
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * _delta

	move_and_slide()
	
	rotation = cat_path.get_follow_rotation()
	rotate_y(deg_to_rad(90))
	
	
func _process(_delta):
	return
	
		
func enable_slide_collision(_enabled: bool):
	base_collision.disabled = _enabled
	slide_collision.disabled = not _enabled
	
	
func update_velocity_to_follow_path(_speed: float, _delta: float):
	var direction = cat_path.get_follow_position() - position
	direction.y = 0.0
	var distance_to_path = direction.length()
	
	if distance_to_path	< lost_path_distance:
		cat_path.increment_progress(_speed * _delta)
		
	direction = cat_path.get_follow_position() - position
	direction.y = 0.0
	distance_to_path = direction.length();
		
			
	direction = direction.normalized()
		
	if direction:
		velocity.x = direction.x * maxf(_speed, distance_to_path)
		velocity.z = direction.z * maxf(_speed, distance_to_path)
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)
		velocity.z = move_toward(velocity.z, 0, _speed)
		
		
func enter_new_path(_path: CatPath):
	cat_path = _path
	cat_path.path_follow.progress = 0.0
	
func get_debug_text() -> String:
	var debug_text = "[b][u]CAT[/u][/b]\n"
	debug_text += "Cat Motion State: %s\n" % state_machine.state.name
	debug_text += "Cat Path progress: %.2f (ratio: %.2f)\n" % [cat_path.get_progress(), cat_path.get_progress_ratio()]
	debug_text += "[color=coral]Ceiling[/color]\n" if ceiling_trigger.has_overlapping_bodies() else "No ceiling\n"
	return debug_text
	
	
