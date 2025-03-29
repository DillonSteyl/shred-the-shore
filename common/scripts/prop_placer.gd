class_name PropPlacer
extends Node3D

const MIN_DISTANCE_COVERED: float = 150.0
const RAYCAST_ORIGIN_Y: float = 10.0

@export var prop_scene: PackedScene
@export var player: Player
@export var min_distance: float
@export var max_distance: float
@export var x_variation: float = 48.0

var _last_prop_z: float = 0.0

@onready var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state


func _ready() -> void:
	while _should_spawn():
		spawn_new_prop()


func _physics_process(_delta: float) -> void:
	if _should_spawn():
		spawn_new_prop()


func _should_spawn():
	return _last_prop_z > player.global_position.z - MIN_DISTANCE_COVERED


func spawn_new_prop() -> void:
	var prop = prop_scene.instantiate()
	var z_offset = randf_range(min_distance, max_distance)
	var x_offset = randf_range(-x_variation, x_variation)

	var y_offset = 0.0
	var query = (
		PhysicsRayQueryParameters3D
		. create(
			Vector3(x_offset, RAYCAST_ORIGIN_Y, z_offset),
			Vector3(x_offset, -RAYCAST_ORIGIN_Y, z_offset),
			1,
		)
	)
	var result = space_state.intersect_ray(query)
	if result.get("position"):
		y_offset = result.get("position").y

	add_child(prop)
	prop.global_position.z = _last_prop_z - z_offset
	prop.global_position.x = x_offset
	prop.global_position.y = y_offset
	_last_prop_z = prop.global_position.z
