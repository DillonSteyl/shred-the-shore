class_name PlayerCarModel
extends Node3D

@export var front_left_wheel: MeshInstance3D
@export var front_right_wheel: MeshInstance3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var front_wheels: Array[MeshInstance3D] = [front_left_wheel, front_right_wheel]


func rotate_wheels(velocity: Vector3) -> void:
	var dir_xz = Vector3(velocity.x, 0, velocity.z).normalized()

	for wheel in front_wheels:
		wheel.look_at(wheel.global_position + dir_xz, Vector3.RIGHT)
