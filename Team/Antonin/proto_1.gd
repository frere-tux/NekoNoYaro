extends Node3D

@onready var label = $Gameplay/Label
@onready var timer = $Gameplay/FinishArea/Timer


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
