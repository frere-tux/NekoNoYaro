extends Node3D

@onready var label = $Gameplay/Label


func _input(event):
	if label.visible and event.is_action_pressed("Confirm"):
		label.visible = false
	elif event.is_action_pressed("Reset"):
		get_tree().reload_current_scene()
	elif event.is_action_pressed("QuitGame"):
		get_tree().quit()
