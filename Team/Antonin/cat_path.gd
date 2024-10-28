class_name CatPath extends Path3D

var path_follow: PathFollow3D
@export var debug_enabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	path_follow = PathFollow3D.new()
	add_child(path_follow)
	path_follow.loop = false
	
	if debug_enabled:
		var debug_mesh = MeshInstance3D.new()
		debug_mesh.mesh = SphereMesh.new()
		debug_mesh.scale *= 0.1 
		path_follow.add_child(debug_mesh)
		

func get_follow_position() -> Vector3:
	return path_follow.position
	
	
func get_follow_rotation() -> Vector3:
	return path_follow.rotation
	
	
func get_progress() -> float:
	return path_follow.progress
	
	
func get_progress_ratio() -> float:
	return path_follow.progress_ratio
	

func increment_progress(_value:float):
	path_follow.progress += _value
	
	
func decrement_progress(_value:float): 
	path_follow.progress -= _value
