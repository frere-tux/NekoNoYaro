extends CatMotionState


func handle_input(_event: InputEvent) -> void:
	var screen_event_state = compute_state_from_mouse_motion(_event)
	
	if _event.is_action_pressed("Jump") or screen_event_state == JUMPING:
		finished.emit(JUMPING)
	elif _event.is_action_pressed("Confirm"):
		finished.emit(RUNNING)


func physics_update(_delta: float) -> void:
	if player_cat.velocity.y < 0.0:
		finished.emit(FALLING)
		return
	elif player_cat.is_on_wall():
		finished.emit(HIT)
		return


func enter(_previous_state_path: String, _data := {}) -> void:
	player_cat.animated_sprite.play("Stand_Idle")
	
	player_cat.velocity = Vector3.ZERO
