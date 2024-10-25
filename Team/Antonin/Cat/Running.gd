extends CatMotionState



func handle_input(event: InputEvent) -> void:
	if player_cat.is_on_floor():
		if event.is_action_pressed("Jump"):
			finished.emit(JUMPING)
		elif event.is_action_pressed("Slide"):
			finished.emit(SLIDING)


func update(delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if player_cat.velocity.y < 0.0:
		finished.emit(FALLING)
		return
	elif player_cat.is_on_wall():
		finished.emit(HIT)
		return
	elif player_cat.cat_path.path_follow.progress_ratio == 1.0:
		finished.emit(IDLE)
		return
		
	player_cat.update_velocity_to_follow_path(player_cat.speed, delta)


func enter(previous_state_path: String, data := {}) -> void:
	player_cat.animated_sprite.play("Run")


func exit() -> void:
	pass
