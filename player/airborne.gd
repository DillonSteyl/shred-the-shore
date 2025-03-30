class_name PlayerAirborneState
extends State

const DOWN_GRAVITY_MULTIPLIER: float = 2.2
const MINIMUM_DURATION_SCORE: float = 0.4

@export var steer_lerp: float

var initial_g: float
var t: float

@onready var state_machine: PlayerStateMachine = get_parent() as PlayerStateMachine
@onready var player: Player = state_machine.player

@onready var _gravity: float = 0.0
@onready var _speed: float = 0.0


func enter() -> void:
	_gravity = initial_g
	_speed = player.speed
	t = 0
	player.score_manager.style_manager.decay_enabled = false


func exit() -> void:
	player.score_manager.style_manager.decay_enabled = true
	if t > MINIMUM_DURATION_SCORE:
		player.score_manager.add_jump(Utils.round_to_dec(t, 1))
		player.boost()


func active_physics_process(delta: float):
	t += delta
	if player.floor_cast.is_colliding():
		state_machine.transition_to(state_machine.grounded)
		return

	var gravity_increment = ProjectSettings.get("physics/3d/default_gravity") * delta
	if _gravity > 0:
		gravity_increment *= DOWN_GRAVITY_MULTIPLIER

	_gravity += gravity_increment

	var movement = _speed * Vector3.FORWARD
	player.steer = lerp(player.steer, Input.get_axis("move_left", "move_right"), delta * steer_lerp)
	movement = movement.rotated(Vector3.UP, -1 * player.steer * player.MAX_STEER_ANGLE)
	player.velocity = movement + _gravity * Vector3.DOWN
	player.move_and_slide()
