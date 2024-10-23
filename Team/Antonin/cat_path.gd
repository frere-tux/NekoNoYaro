class_name CatPath

extends Path3D

var path_follow: PathFollow3D

# Called when the node enters the scene tree for the first time.
func _ready():
	path_follow = PathFollow3D.new()
	add_child(path_follow)
	
	path_follow.loop = false
