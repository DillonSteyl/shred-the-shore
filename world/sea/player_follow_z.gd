extends Node3D

@export var player: Player
@export var follow_y: bool = false

var z_offset: float
var y_offset: float


func _ready() -> void:
	z_offset = global_position.z - player.global_position.z
	y_offset = global_position.y - player.global_position.z


func _process(_delta: float) -> void:
	global_position.z = player.global_position.z + z_offset
	if follow_y:
		global_position.y = player.global_position.y + y_offset
