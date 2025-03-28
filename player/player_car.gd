extends CharacterBody3D

const VISUAL_ROTATION: float = deg_to_rad(7.0)
const VISUAL_TILT: float = deg_to_rad(6.0)

@export var base_speed: float = 40.0
@export var strafe_speed: float = 35.0
@export var strafe_lerp: float = 20.0

# refs
@onready var model: Node3D = $Model
@onready var floor_cast: RayCast3D = $%FloorCast

# persistent movement vars
@onready var _strafe: float = 0.0
@onready var _gravity: float = 0.0
# visual forward/back tilt
@onready var _z_tilt: float = 0.0


func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_apply_visual_rotation(delta)


func _handle_movement(delta: float):
	if not is_on_floor():
		_gravity += ProjectSettings.get("physics/3d/default_gravity") * delta
	else:
		_gravity = 0.0

	var movement = base_speed * Vector3.FORWARD
	_strafe = lerp(_strafe, Input.get_axis("move_left", "move_right"), delta * strafe_lerp)
	movement += _strafe * Vector3.RIGHT * strafe_speed

	velocity = movement + Vector3.DOWN * _gravity
	move_and_slide()


func _apply_visual_rotation(delta) -> void:
	var rot_angle = _strafe * VISUAL_ROTATION
	var tilt_angle = _strafe * VISUAL_TILT

	var goal_z_tilt = 0.0
	if floor_cast.is_colliding():
		var floor_normal = floor_cast.get_collision_normal()
		goal_z_tilt = floor_normal.signed_angle_to(Vector3.UP, Vector3.LEFT)

	var z_tilt_lerp = 15.0
	if not is_on_floor():
		z_tilt_lerp = 5.0
	_z_tilt = lerp(_z_tilt, goal_z_tilt, delta * z_tilt_lerp)

	model.basis = (
		basis
		. rotated(Vector3.FORWARD, tilt_angle)
		. rotated(Vector3.UP, -rot_angle)
		. rotated(Vector3.RIGHT, _z_tilt)
	)
