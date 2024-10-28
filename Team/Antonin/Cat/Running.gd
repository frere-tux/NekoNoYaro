extends CatMotionState


func handle_input(_event: InputEvent) -> void:
	var screen_event_state = compute_state_from_mouse_motion(_event)
	
	if player_cat.is_on_floor() and player_cat.cat_path.path_follow.progress > 1.0:
		if _event.is_action_pressed("Jump") or screen_event_state == JUMPING:
			finished.emit(JUMPING)
		elif _event.is_action_pressed("Slide") or screen_event_state == SLIDING:
			finished.emit(SLIDING)


func physics_update(_delta: float) -> void:
	if player_cat.velocity.y < 0.0:
		finished.emit(FALLING)
		return
	elif player_cat.is_on_wall():
		finished.emit(HIT)
		return
	elif player_cat.cat_path.path_follow.progress_ratio == 1.0:
		finished.emit(IDLE)
		return
		
	player_cat.update_velocity_to_follow_path(player_cat.speed, _delta)


func enter(_previous_state_path: String, _data := {}) -> void:
	player_cat.animated_sprite.play("Run")
