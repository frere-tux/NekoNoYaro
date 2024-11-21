extends Control

@onready var debug_window_container = $DebugWindowContainer

var objects_to_display: Dictionary


func _ready():
	add_object_to_display(self, "ToggleDebugHelp")
	
	
func _unhandled_input(_event):
	for object in objects_to_display:
		var action = objects_to_display[object][1]
		if _event.is_action_pressed(action):
			var debug_window = objects_to_display[object][0]
			if debug_window:
				objects_to_display[object][0] = null
				debug_window_container.remove_child(debug_window)
				debug_window.queue_free()
			else:
				var debug_window_scene = preload("res://Debug/debug_window.tscn")
				debug_window = debug_window_scene.instantiate()
				objects_to_display[object][0] = debug_window
				debug_window_container.add_child(debug_window)
				


func _process(delta):
	for object in objects_to_display:
		var debug_window = objects_to_display[object][0]
		if debug_window:
			debug_window.text = object.get_debug_text()
			
	
func add_object_to_display(_object: Node, _action: String):
	if _object.has_method("get_debug_text"):
		objects_to_display[_object] = [null, _action]
	else:
		printerr("DebugManager::add_object_to_display: object %s should implement a get_debug_text() method" % _object.name)
	
	
func remove_object_to_display(_object: Node):
	if not objects_to_display.has(_object):
		return
	
	var debug_window = objects_to_display[_object][0]
	if debug_window:
		debug_window_container.remove_child(debug_window)
		debug_window.queue_free()
	
	objects_to_display.erase(_object)


func get_debug_text() -> String:
	var debug_text = "[b][u]DEBUG MANAGER[/u][/b]\n"
	for object in objects_to_display:
		var action = objects_to_display[object][1]
		var color = "white" if not objects_to_display[object][0] else "yellow_green"
		debug_text += "[color=%s]%s : %s[/color]\n" % [color, action.capitalize(), InputMap.action_get_events(action)[0].as_text()]
	return debug_text
