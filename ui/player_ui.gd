class_name PlayerUI
extends Control

@onready var score_label: Label = $ScoreLabel


func update_score(new_score: int):
	score_label.text = "{score}".format({"score": new_score})
