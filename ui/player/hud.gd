extends Control


func _ready() -> void:
	$AnimationPlayer.play("tutorial")
	$AnimationPlayer.seek(0, true)
