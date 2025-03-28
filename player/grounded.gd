class_name PlayerGroundedState
extends State

@onready var state_machine: PlayerStateMachine = get_parent() as PlayerStateMachine
@onready var player: Player = state_machine.player


func active_physics_process(_delta: float) -> void:
	if not state_machine.player.floor_cast.is_colliding():
		state_machine.airbourne.initial_g = -player.get_real_velocity().y
		state_machine.transition_to(state_machine.airbourne)
		return

	_handle_movement()


func _handle_movement():
	var movement = player.base_speed * Vector3.FORWARD
	movement = movement.rotated(Vector3.UP, -1 * player._steer * player.MAX_STEER_ANGLE)
	player.velocity = movement
	player.move_and_slide()
