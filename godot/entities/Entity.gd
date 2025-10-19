class_name Entity
extends CharacterBody2D

var _health: float = 100.0

@export
var _code_edit: TextEdit
@export
var _run_button: Button
@export
var _stats: EntityStats

@onready
var _anim_tree: AnimationTree = $AnimationTree
@onready
var _anim_tree_fsm: AnimationNodeStateMachinePlayback = _anim_tree["parameters/playback"]
@onready
var _sprite: AnimatedSprite2D = $Sprite

@onready
var _idle_state: State = $XSM/Locomotion/Idle
@onready
var _walk_state: State = $XSM/Locomotion/Walk
@onready
var _run_state: State = $XSM/Locomotion/Run
@onready
var _dash_state: State = $XSM/Locomotion/Dash

@onready
var _locomotion_state: State = $XSM/Locomotion

@onready
var _hit_box: HitBox = $Sprite/HitBox
@onready
var _status_label: Label = $Status

@onready
var _xsm: State = $XSM

var _mouse_entered := false

var _facing_direction := 1.0


func _ready() -> void:
	_anim_tree.active = true


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left_mouse_button") and _mouse_entered:
		position = get_global_mouse_position()
		return


func _on_mouse_entered() -> void:
	_mouse_entered = true


func _on_mouse_exited() -> void:
	_mouse_entered = false


func take_damage(damage: float) -> void:
	if _idle_state.active or _walk_state.active or _run_state.active:
		_health -= damage
		_locomotion_state.change_state(&"Hurt")


func _on_hurt_box_area_entered(area: HitBox) -> void:
	if area == null:
		return

	if _hit_box == area:
		return

	if area is HitBox:
		take_damage(area.damage)
