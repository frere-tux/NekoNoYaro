extends Node3D

@onready var label = $Gameplay/Label
@onready var timer = $Gameplay/FinishArea/Timer
@onready var directional_light_3d_1 = $Lights/DirectionalLight3D1
@onready var cat: CharacterBody3D = $Gameplay/Cat

var initial_light_orientation: Vector3 


func _input(_event):
	if label.visible and _event.is_action_pressed("Confirm"):
		label.visible = false
	elif _event.is_action_pressed("Reset"):
		get_tree().reload_current_scene()
	elif _event.is_action_pressed("QuitGame"):
		get_tree().quit()


func _on_finish_area_body_entered(_body):
	timer.start()


func _on_timer_timeout():
	get_tree().reload_current_scene()


func _ready():
	initial_light_orientation = directional_light_3d_1.rotation
