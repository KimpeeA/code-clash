@tool
class_name IdleState
extends EntityState


func _on_enter(args) -> void:
	super(args)


func _on_update(_delta: float) -> void:
	if Input.is_action_just_pressed(&"dash"):
		var dash_state := get_state(&"Dash")
		dash_state.next_state = self.get_path()
		change_state(&"Dash")

	if Input.get_axis(&"left", &"right"):
		change_state(&"Walk")

	if Input.is_action_pressed(&"jump"):
		change_state(&"Jump")

	if not _agent.is_on_floor():
		change_state(&"Fall")
