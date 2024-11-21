extends Node3D

@onready var label = $Gameplay/Label
@onready var timer = $Gameplay/ResetTimer
@onready var directional_light_3d_1 = $Lights/DirectionalLight3D1
@onready var cat: CharacterBody3D = $Gameplay/Cat


func _ready():
	DebugManager.add_object_to_display(self, "ToggleDebugScene")
	

func _exit_tree():
	DebugManager.remove_object_to_display(self)


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
	

func get_debug_text() -> String:
	var debug_text = "[b][u]PROTO 1[/u][/b]\n"
	debug_text += "FPS: %.2f\n" % Engine.get_frames_per_second()
	if timer.time_left > 0.0:
		debug_text +="[color=coral]Reset in %.2f seconds[/color]\n" % timer.time_left
	return debug_text
