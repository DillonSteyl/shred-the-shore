extends Node3D

@export var closed_umbrella: PackedScene
@export var mesh_slot: Node3D

@onready var detection_area: DestructibleDetectionArea = $DestructibleDetectionArea


func _ready():
	detection_area.hit.connect(_on_hit)


func _on_hit():
	mesh_slot.get_child(0).queue_free()
	mesh_slot.add_child(closed_umbrella.instantiate())
