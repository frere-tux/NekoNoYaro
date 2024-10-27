extends Node3D

@onready var label = $Gameplay/Label
@onready var timer = $Gameplay/FinishArea/Timer
@onready var directional_light_3d_1 = $Lights/DirectionalLight3D1
@onready var cat: CharacterBody3D = $Gameplay/Cat

var initial_light_orientation: Vector3 


func _input(event):
	if label.visible and event.is_action_pressed("Confirm"):
		label.visible = false
	elif event.is_action_pressed("Reset"):
		get_tree().reload_current_scene()
	elif event.is_action_pressed("QuitGame"):
		get_tree().quit()


func _on_finish_area_body_entered(body):
	timer.start()
	

func _on_timer_timeout():
	get_tree().reload_current_scene()
	
func _ready():
	initial_light_orientation =directional_light_3d_1.rotation
	
func _process(delta):
	directional_light_3d_1.rotation = cat.rotation + initial_light_orientation
