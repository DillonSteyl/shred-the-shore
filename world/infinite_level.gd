class_name InfiniteLevel
extends Node3D

@export var player: Player

@onready var ramp_distance: float = 30.0


func _ready() -> void:
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes:
		player = player_nodes[0]
