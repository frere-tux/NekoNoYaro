class_name CatPath extends Path3D

@onready var path_follow = $PathFollow3D
@onready var enter_trigger = $EnterTrigger

@export var debug_enabled: bool = false

	
func _ready():
	if debug_enabled:
		var debug_mesh = MeshInstance3D.new()
		debug_mesh.mesh = SphereMesh.new()
		debug_mesh.scale *= 0.1 
		path_follow.add_child(debug_mesh)
		

func get_follow_position() -> Vector3:
	return path_follow.global_position
	
	
func get_follow_rotation() -> Vector3:
	return path_follow.global_rotation
	
	
func get_progress() -> float:
	return path_follow.progress
	
	
func get_progress_ratio() -> float:
	return path_follow.progress_ratio
	

func increment_progress(_value:float):
	path_follow.progress += _value
	
	
func decrement_progress(_value:float): 
	path_follow.progress -= _value


func _on_path_trigger_entered(_body):
	var cat = _body as Cat
	if cat:
		cat.enter_new_path(self)
