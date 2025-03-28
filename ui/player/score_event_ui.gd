class_name ScoreEventUI
extends Control

@onready var name_label: Label = $%NameLabel
@onready var score_label: Label = $%ScoreLabel
@onready var multiplier_label: Label = $%MultiplierLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func show_event(event_name: String, score: int, multiplier: float):
	animation_player.play("show")
	animation_player.seek(0, true)
	score_label.text = "+{score}".format({"score": score})
	multiplier_label.text = "x{multiplier}".format({"multiplier": multiplier})
	name_label.text = event_name
