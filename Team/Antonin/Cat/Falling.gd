extends CatMotionState

var go_to_state: String


func physics_update(_delta: float) -> void:
	if player_cat.is_on_wall():
		finished.emit(HIT)
		return
	
	if player_cat.velocity.y >= 0.0 and player_cat.is_on_floor():
		match go_to_state:
			IDLE:
				finished.emit(IDLE)
				return
			_:
				finished.emit(RUNNING)
				return
	
	if go_to_state != IDLE:
		player_cat.update_velocity_to_follow_path(player_cat.speed, _delta)


func enter(_previous_state_path: String, _data := {}) -> void:
	player_cat.animated_sprite.play("Fall")
	
	go_to_state = _data.get("GoTo", _previous_state_path)
