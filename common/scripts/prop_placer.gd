class_name PropPlacer
extends Node3D

const MIN_DISTANCE_COVERED: float = 250.0
const RAYCAST_ORIGIN_Y: float = 5.0

@export var prop_scenes: Array[PackedScene]
@export var player: Player
@export var starting_offset: float = 10.0
@export var min_distance: float
@export var max_distance: float
@export var x_variation: float = 48.0
@export var randomize_y_rotation: bool = false

@onready var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state

@onready var _last_prop_z: float = -starting_offset


func _ready() -> void:
	while _should_spawn():
		spawn_new_prop()


func _physics_process(_delta: float) -> void:
	if _should_spawn():
		spawn_new_prop()


func _should_spawn():
	return _last_prop_z > player.global_position.z - MIN_DISTANCE_COVERED


func spawn_new_prop() -> void:
	var prop_scene = prop_scenes[randi() % len(prop_scenes)]
	var prop: Node3D = prop_scene.instantiate()
	var z_offset = randf_range(min_distance, max_distance)
	var x_offset = randf_range(-x_variation, x_variation)

	var y_offset = 0.0
	var query = (
		PhysicsRayQueryParameters3D
		. create(
			Vector3(x_offset, RAYCAST_ORIGIN_Y, _last_prop_z - z_offset),
			Vector3(x_offset, -100.0, _last_prop_z - z_offset),
		)
	)
	var result = space_state.intersect_ray(query)
	if result.get("position"):
		y_offset = result.get("position").y

	add_child(prop)
	prop.global_position.z = _last_prop_z - z_offset
	prop.global_position.x = x_offset
	prop.global_position.y = y_offset
	if randomize_y_rotation:
		prop.rotate_y(randf_range(0, 2 * PI))
	_last_prop_z = prop.global_position.z
