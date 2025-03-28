class_name ScoreEventUI
extends Control

@onready var name_label: Label = $%NameLabel
@onready var score_label: Label = $%ScoreLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func show_event(event_name: String, score: float):
	animation_player.play("show")
	animation_player.seek(0, true)
	score_label.text = "+{score}".format({"score": score})
	name_label.text = event_name
