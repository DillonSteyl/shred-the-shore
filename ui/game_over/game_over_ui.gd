class_name GameOverUI
extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var play_again_button: Button = $%PlayButton
@onready var exit_button: Button = $%ExitButton
@onready var score_label: Label = $%ScoreLabel


func open() -> void:
	visible = true
	animation_player.play("show")


func show_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
