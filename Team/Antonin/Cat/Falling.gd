extends CatMotionState

var go_to_state: String

func handle_input(event: InputEvent) -> void:
	pass


func update(delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if player_cat.velocity.y >= 0.0 and player_cat.is_on_floor():
		match go_to_state:
			IDLE:
				finished.emit(IDLE)
				return
			_:
				finished.emit(RUNNING)
				return
	
	if go_to_state != IDLE:
		player_cat.update_velocity_to_follow_path(player_cat.speed, delta)


func enter(previous_state_path: String, data := {}) -> void:
	player_cat.animated_sprite.play("Fall")
	
	go_to_state = data.get("GoTo", previous_state_path)


func exit() -> void:
	pass
