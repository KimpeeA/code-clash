@tool
class_name IdleState
extends EntityState


func _on_enter(args) -> void:
	super(args)
	_agent.set_animation(&"idle")
	_agent.velocity = Vector2.ZERO


func _on_update(_delta: float) -> void:
	if Input.get_axis(&"left", &"right"):
		change_state(&"Move")
		return

	if Input.is_action_pressed(&"dash"):
		change_state_with_next(&"Dash")
		return

	if Input.is_action_pressed(&"jump"):
		change_state(&"Jump")
		return

	_agent.move_and_slide()

	if not _agent.is_on_floor():
		change_state_with_next(&"Fall")
		return
