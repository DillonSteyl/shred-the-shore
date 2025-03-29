class_name PlayerGroundedState
extends State

const MAX_MOVE_CACHE_LENGTH: int = 10

@export var steer_lerp: float

@onready var state_machine: PlayerStateMachine = get_parent() as PlayerStateMachine
@onready var player: Player = state_machine.player

var movement_cache: Array[Vector3]


func enter() -> void:
	if not player.is_node_ready():
		await player.ready
	player.model.animation_player.play("land")
	movement_cache = []


func active_physics_process(delta: float) -> void:
	if not state_machine.player.floor_cast.is_colliding():
		var avg_velocity = get_average_velocity()
		state_machine.airborne.initial_g = min(-avg_velocity.y, 0.0)
		state_machine.transition_to(state_machine.airborne)
		return

	_handle_movement(delta)
	_populate_cache()


func _handle_movement(delta: float):
	var movement = player.speed * Vector3.FORWARD
	player.steer = lerp(player.steer, Input.get_axis("move_left", "move_right"), delta * steer_lerp)
	movement = movement.rotated(Vector3.UP, -1 * player.steer * player.MAX_STEER_ANGLE)
	player.velocity = movement + Vector3.DOWN
	player.move_and_slide()


func _populate_cache():
	if len(movement_cache) > MAX_MOVE_CACHE_LENGTH:
		movement_cache.pop_front()

	movement_cache.append(player.get_real_velocity())


func get_average_velocity() -> Vector3:
	if len(movement_cache) == 0:
		return Vector3.ZERO

	var m_sum = Vector3.ZERO
	for m in movement_cache:
		m_sum += m
	return m_sum / len(movement_cache)
