extends Area3D

func _on_cat_entered(_body):
	var cat = _body as Cat
	if cat:
		cat.can_jump = false


func _on_cat_exited(_body):
	var cat = _body as Cat
	if cat:
		cat.can_jump = true
