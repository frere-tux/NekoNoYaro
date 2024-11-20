extends CatMotionState

var slide_time: float = 0.0

func handle_input(_event: InputEvent) -> void:
	if player_cat.can_jump and _event.is_action_pressed("Jump"):
		finished.emit(JUMPING)


func physics_update(_delta: float) -> void:
	if player_cat.velocity.y < 0.0:
		finished.emit(FALLING)
		return
	elif player_cat.is_on_wall():
		finished.emit(HIT)
		return
	elif player_cat.cat_path.get_progress_ratio() == 1.0:
		finished.emit(IDLE)
		return
		
	player_cat.update_velocity_to_follow_path(player_cat.slide_speed, _delta)
		
	if (slide_time < player_cat.max_slide_time and (slide_time < player_cat.min_slide_time or Input.is_action_pressed("Slide") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) or player_cat.ceiling_trigger.has_overlapping_bodies()):
		slide_time += _delta
	else:
		finished.emit(RUNNING)


func enter(_previous_state_path: String, _data := {}) -> void:
	player_cat.animated_sprite.play("Slide")
	
	slide_time = 0.0
	
	player_cat.enable_slide_collision(true)


func exit() -> void:
	player_cat.enable_slide_collision(false)
