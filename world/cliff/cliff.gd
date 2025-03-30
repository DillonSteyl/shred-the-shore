class_name Cliff
extends Node3D

const GOAL_NUM_CLIFFS: int = 15
const CLIFF_WIDTH: float = 60.0
const SPAWN_DISTANCE_THRESHOLD: float = 350.0

@export var cliff_scene: PackedScene
@export var player: Player

@onready var cliffs: Array[Node3D] = []
var _final_z: float = 0.0


func _ready() -> void:
	for i in range(GOAL_NUM_CLIFFS):
		spawn_cliff()


func spawn_cliff() -> void:
	if len(cliffs) > GOAL_NUM_CLIFFS:
		var cliff_to_remove = cliffs.pop_front()
		cliff_to_remove.queue_free()

	var spawn_offset = Vector3.ZERO
	if cliffs:
		spawn_offset = cliffs[-1].position + Vector3.FORWARD * CLIFF_WIDTH

	var cliff = cliff_scene.instantiate()
	add_child(cliff)
	cliff.position = spawn_offset
	cliffs.append(cliff)
	_final_z = cliff.global_position.z


func _physics_process(_delta: float) -> void:
	if abs(player.global_position.z - _final_z) < SPAWN_DISTANCE_THRESHOLD:
		spawn_cliff()
