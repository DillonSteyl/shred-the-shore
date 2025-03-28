class_name PlayerUI
extends Control

@onready var score_label: Label = $ScoreLabel
@onready var score_event_ui: ScoreEventUI = $ScoreEvent


func update_score(new_score: int):
	score_label.text = "{score}".format({"score": new_score})
