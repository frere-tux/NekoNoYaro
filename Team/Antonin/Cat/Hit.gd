extends CatMotionState



func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("Jump"):
		finished.emit(JUMPING)


func update(delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if player_cat.velocity.y < 0.0:
		finished.emit(FALLING)
		return
	elif not player_cat.is_on_wall():
		finished.emit(RUNNING)
		return
		
	player_cat.update_velocity_to_follow_path(player_cat.speed, delta)


func enter(previous_state_path: String, data := {}) -> void:
	player_cat.animated_sprite.play("Hit")


func exit() -> void:
	pass
