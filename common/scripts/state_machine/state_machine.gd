class_name StateMachine
extends Node

signal state_changed(old_state: State, new_state: State)

@export var initial_state = NodePath()

@onready var active_state: State = get_node_or_null(initial_state)
@onready var last_state: State = active_state


func _ready() -> void:
	if not active_state:
		push_error("State machine is not configured with an initial state.")
		return

	active_state.enter()


func _process(delta: float) -> void:
	if not active_state:
		return

	active_state.active_process(delta)


func _physics_process(delta: float) -> void:
	if not active_state:
		return

	active_state.active_physics_process(delta)


func transition_to(new_state: State) -> void:
	if new_state == active_state:
		return

	if not active_state.can_exit:
		push_warning(
			"Cannot exit active_state {state_name}".format({"state_name": active_state.name})
		)
		return

	if not new_state.can_enter:
		push_warning("Cannot enter state {state_name}".format({"state_name": new_state.name}))
		return

	last_state = active_state

	active_state.exit()
	active_state = new_state
	active_state.enter()

	state_changed.emit(last_state, new_state)
