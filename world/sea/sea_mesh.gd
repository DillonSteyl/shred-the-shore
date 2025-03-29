extends MeshInstance3D

@export var player: Player

var z_offset: float


func _ready() -> void:
	z_offset = global_position.z - player.global_position.z


func _process(_delta: float) -> void:
	global_position.z = player.global_position.z + z_offset
