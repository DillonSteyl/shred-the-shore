extends Node3D

@export var particles: Array[GPUParticles3D] = []


func _ready() -> void:
	for child in get_children():
		if child is GPUParticles3D:
			particles.append(child)
			child.emitting = true
