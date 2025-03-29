class_name DestructibleDetectionArea
extends Area3D

@export var rigidbody: RigidBody3D


func _ready() -> void:
	rigidbody.freeze = true
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if not body is Player:
		return

	var player = body as Player
	player.score_manager.collide()
	rigidbody.freeze = false

	get_tree().create_timer(4.0).timeout.connect(owner.queue_free)
