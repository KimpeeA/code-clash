@tool
class_name JumpState
extends EntityState


@export
var _default_jump_force := 200.0

var _jump_force := 0.0  # positive = upward


func _on_enter(args) -> void:
	super(args)

	_jump_force = float(_args.get("jump_force", _default_jump_force))

	_agent.velocity.y = -_jump_force
	_agent.move_and_slide()


func _after_enter(args) -> void:
	change_state(&"Fall")
