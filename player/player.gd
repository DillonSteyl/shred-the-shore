class_name Player
extends CharacterBody3D

const VISUAL_ROTATION: float = deg_to_rad(25.0)
const VISUAL_TILT: float = deg_to_rad(16.0)
const MAX_STEER_ANGLE: float = deg_to_rad(55.0)
const BOOST_MULTIPLIER: float = 1.0
const SPEED_INCREASE_DURATION: float = 120.0

@export var min_speed: float = 40.0
@export var max_speed: float = 80.0

@export var boost_wait_time: float = 2.0
@export var steer_lerp: float = 4.0
@export var explosion_scene: PackedScene

# refs
@onready var model: PlayerCarModel = $%PlayerCarModel
@onready var floor_cast: ShapeCast3D = $%FloorCast
@onready var state_machine: PlayerStateMachine = $%PlayerStateMachine
@onready var score_manager: ScoreManager = $%ScoreManager
@onready var ui: PlayerUI = $%PlayerUI

# persistent movement vars
@onready var steer: float = 0.0
@onready var base_speed: float = min_speed
@onready var speed: float = min_speed

# visual forward/back tilt
@onready var _z_tilt: float = 0.0

@onready var boost_timer: Timer = Timer.new()


func _ready() -> void:
	score_manager.score_changed.connect(ui.update_score)
	score_manager.score_event_triggered.connect(ui.score_event_ui.show_event)
	score_manager.style_manager.style_changed.connect(ui.style_meter_ui.set_style)
	score_manager.style_manager.bracket_changed.connect(ui.style_meter_ui.set_bracket)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	add_child(boost_timer)
	boost_timer.wait_time = boost_wait_time
	boost_timer.one_shot = true

	var tween = get_tree().create_tween()
	tween.tween_property(self, "base_speed", max_speed, SPEED_INCREASE_DURATION)


func _physics_process(delta: float) -> void:
	speed = base_speed
	if not boost_timer.is_stopped():
		speed *= BOOST_MULTIPLIER

	_rotate_model(delta)
	model.rotate_wheels(velocity)


func die():
	var explosion = explosion_scene.instantiate()
	add_child(explosion)
	state_machine.transition_to(state_machine.dead)
	model.visible = false
	ui.show_game_over(score_manager.score)


func boost():
	boost_timer.start()


func _rotate_model(delta) -> void:
	var rot_angle = steer * VISUAL_ROTATION
	var tilt_angle = steer * VISUAL_TILT

	var goal_z_tilt = -deg_to_rad(20.0)
	var z_tilt_lerp = 2.0
	if floor_cast.is_colliding():
		var floor_normal = floor_cast.get_collision_normal(0)
		goal_z_tilt = floor_normal.signed_angle_to(Vector3.UP, Vector3.LEFT)
		z_tilt_lerp = 15.0

	_z_tilt = lerp(_z_tilt, goal_z_tilt, delta * z_tilt_lerp)

	model.basis = (
		basis
		. rotated(Vector3.FORWARD, -tilt_angle)
		. rotated(Vector3.UP, -rot_angle)
		. rotated(Vector3.RIGHT, _z_tilt)
	)
