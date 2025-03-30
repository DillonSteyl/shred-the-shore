extends RigidBody3D

@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body) -> void:
	if not body is Player:
		return
	audio.pitch_scale = randf_range(0.8, 1.2)
	audio.play()
