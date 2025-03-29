extends Node3D

@export var mesh_choices: Array[PackedScene]

@onready var mesh_slot: Node3D = $RigidBody3D/MeshSlot


func _ready() -> void:
	mesh_slot.get_child(0).queue_free()
	mesh_slot.add_child(mesh_choices[randi() % len(mesh_choices)].instantiate())
