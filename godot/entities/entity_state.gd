@tool
class_name EntityState
extends State

var _agent: Entity
var _args: Dictionary


func _on_enter(args) -> void:
	if args is Dictionary:
		_args = args
	else:
		_args = {}

	_agent = self.target


func change_state_with_next(
	state_name: StringName, next_state_path: NodePath = self.get_path()
) -> void:
	var transient_state := get_state(state_name)
	transient_state.next_state = next_state_path
	change_state_node(transient_state)
