class_name State
extends Node

signal entered
signal exited

@export var can_exit: bool = true
@export var can_enter: bool = true

var _is_active: bool = false


func _ready():
	if not get_parent() is StateMachine:
		push_error("State must be a child of a StateMachine.")
		queue_free()
		return


# Virtual function. Corresponds to the `_process()` callback.
func active_process(_delta: float) -> void:
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func active_physics_process(_delta: float) -> void:
	pass


# Virtual function. Called by the state machine upon changing the active state.
func enter() -> void:
	_is_active = true
	entered.emit()


# Virtual function. Called by the state machine before changing the active state.
func exit() -> void:
	_is_active = false
	exited.emit()


func is_active() -> bool:
	return _is_active
