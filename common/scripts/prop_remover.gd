## Util node to attach to props that can be safely removed once they're behind the player
class_name PropRemover
extends Node

const OFFSET: float = 50.0

@onready var player: Player
@onready var prop: Node3D


func _ready() -> void:
	var player_nodes = get_tree().get_nodes_in_group("player")
	if not player_nodes:
		push_error("No player in tree.")
		queue_free()

	player = player_nodes[0]
	prop = owner as Node3D


func _physics_process(_delta: float) -> void:
	if prop.global_position.z > player.global_position.z + OFFSET:
		prop.queue_free()
