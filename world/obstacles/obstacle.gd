class_name Obstacle
extends Area3D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body) -> void:
	if not body is Player:
		return
	var player = body as Player
	player.die()
