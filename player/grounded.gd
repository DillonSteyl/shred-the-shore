class_name PlayerGroundedState
extends State

@export var steer_lerp: float

@onready var state_machine: PlayerStateMachine = get_parent() as PlayerStateMachine
@onready var player: Player = state_machine.player


func enter() -> void:
	if not player.is_node_ready():
		await player.ready
	player.model.animation_player.play("land")


func active_physics_process(delta: float) -> void:
	if not state_machine.player.floor_cast.is_colliding():
		state_machine.airborne.initial_g = -player.get_real_velocity().y
		state_machine.transition_to(state_machine.airborne)
		return

	_handle_movement(delta)


func _handle_movement(delta: float):
	var movement = player.base_speed * Vector3.FORWARD
	player.steer = lerp(player.steer, Input.get_axis("move_left", "move_right"), delta * steer_lerp)
	movement = movement.rotated(Vector3.UP, -1 * player.steer * player.MAX_STEER_ANGLE)
	player.velocity = movement + Vector3.DOWN
	player.move_and_slide()
