class_name PropPlacer
extends Node3D

const MIN_DISTANCE_COVERED: float = 250.0
const RAYCAST_ORIGIN_Y: float = 5.0
const FREQUENCY_CHANGE_DURATION: float = 120.0

@export var prop_scenes: Array[PackedScene]
@export var player: Player
@export var starting_offset: float = 10.0
@export var start_min_distance: float
@export var start_max_distance: float
@export var end_min_distance: float
@export var end_max_distance: float
@export var x_variation: float = 48.0
@export var randomize_y_rotation: bool = false
@export var x_variations: Array[float] = []
@export var align_y: bool = false

@onready var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state

@onready var _last_prop_z: float = -starting_offset

@onready var min_distance: float = start_min_distance
@onready var max_distance: float = start_max_distance


func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "min_distance", end_min_distance, FREQUENCY_CHANGE_DURATION)
	tween.tween_property(self, "max_distance", end_max_distance, FREQUENCY_CHANGE_DURATION)

	spawn_new_prop()
	while _should_spawn():
		spawn_new_prop()


func _physics_process(_delta: float) -> void:
	if _should_spawn():
		spawn_new_prop()


func _should_spawn():
	if not player:
		return false
	return _last_prop_z > player.global_position.z - MIN_DISTANCE_COVERED


func _align_up(node_basis: Basis, normal: Vector3):
	var result = Basis()
	var basis_scale = node_basis.get_scale()

	result.x = normal.cross(node_basis.z)
	result.y = normal
	result.z = node_basis.x.cross(normal)

	result = result.orthonormalized()
	result.x *= basis_scale.x
	result.y *= basis_scale.y
	result.z *= basis_scale.z

	return result


func spawn_new_prop() -> void:
	var prop_index = randi() % len(prop_scenes)

	var prop_scene = prop_scenes[prop_index]
	var prop: Node3D = prop_scene.instantiate()
	var z_offset = randf_range(min_distance, max_distance)

	var x_var = x_variation
	if x_variations:
		x_var = x_variations[prop_index]

	var x_offset = randf_range(-x_var, x_var)

	var y_offset = 0.0
	var query = (
		PhysicsRayQueryParameters3D
		. create(
			Vector3(x_offset, RAYCAST_ORIGIN_Y, _last_prop_z - z_offset),
			Vector3(x_offset, -100.0, _last_prop_z - z_offset),
		)
	)
	var result = space_state.intersect_ray(query)
	var surface_normal: Vector3 = Vector3.UP
	if result:
		y_offset = result.get("position").y
		surface_normal = result.get("normal")

	add_child(prop)
	prop.global_position.z = _last_prop_z - z_offset
	prop.global_position.x = x_offset
	prop.global_position.y = y_offset
	if align_y:
		prop.basis = _align_up(prop.basis, surface_normal)
	if randomize_y_rotation:
		prop.rotate_y(randf_range(0, 2 * PI))
	_last_prop_z = prop.global_position.z
