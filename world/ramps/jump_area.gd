class_name JumpArea
extends Area3D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	return


func _on_body_entered(body: Node3D):
	var player = body as Player
	player.can_trick = true


func _on_body_exited(body: Node3D):
	var player = body as Player
	player.can_trick = false
