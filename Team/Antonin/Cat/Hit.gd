extends CatMotionState

var path_progress_on_hit: float = 0.0


func physics_update(_delta: float) -> void:
	if not player_cat.is_on_wall() and player_cat.is_on_floor():
		finished.emit(RUNNING)
		return
	
	player_cat.update_velocity_to_follow_path(0, _delta)


func enter(_previous_state_path: String, _data := {}) -> void:
	player_cat.animated_sprite.play("Hit")
	
	path_progress_on_hit = player_cat.cat_path.get_progress()
	player_cat.cat_path.decrement_progress(player_cat.hit_path_setback)
	player_cat.velocity.y = player_cat.hit_jum_velocity
