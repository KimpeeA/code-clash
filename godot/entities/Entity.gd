class_name Entity
extends CharacterBody2D

var _health: float = 100.0

@export var _code_edit: TextEdit
@export var _run_button: Button
@export var _stats: EntityStats

@onready var _anim_player: AnimationPlayer = $AnimationPlayer
@onready var _anim_tree: AnimationTree = $AnimationTree
@onready var _anim_tree_fsm: AnimationNodeStateMachinePlayback = _anim_tree["parameters/playback"]
@onready var _sprite: AnimatedSprite2D = $Sprite

@onready var _idle_state: State = $XSM/Persistent/Idle
@onready var _move_state: State = $XSM/Persistent/Move

@onready var _dash_state: State = $XSM/Transient/Dash

@onready var _persistent_state: State = $XSM/Persistent
@onready var _transient_state: State = $XSM/Transient

@onready var _hit_box: HitBox = $Sprite/HitBox
@onready var _status_label: Label = $Status

@onready var _xsm: State = $XSM

var _mouse_entered := false

var _facing_direction := 1.0:
	set(value):
		_facing_direction = sign(value)


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
	if _idle_state.active or _move_state.active:
		_health -= damage
		_persistent_state.change_state(&"Hurt")


func _on_hurt_box_area_entered(area: HitBox) -> void:
	if area == null:
		return

	if _hit_box == area:
		return

	if area is HitBox:
		take_damage(area.damage)


func set_animation(animation_name: StringName) -> void:
	if _anim_player.current_animation == animation_name:
		return

	_anim_player.play(animation_name)


func direction_change(new_direction: float) -> void:
	if is_equal_approx(_facing_direction, new_direction):
		return

	if is_zero_approx(new_direction):
		return

	_facing_direction = new_direction
	_sprite.scale.x = new_direction
