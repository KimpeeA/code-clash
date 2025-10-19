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
