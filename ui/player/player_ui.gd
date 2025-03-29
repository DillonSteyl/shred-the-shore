class_name PlayerUI
extends Control

@onready var hud = $HUD
@onready var score_label: Label = $%ScoreLabel
@onready var score_event_ui: ScoreEventUI = $%ScoreEvent
@onready var style_meter_ui: StyleMeterUI = $%StyleMeterUI
@onready var game_over_ui: GameOverUI = $GameOverUI


func update_score(new_score: int):
	score_label.text = "{score}".format({"score": new_score})


func show_game_over(score: int):
	hud.queue_free()
	game_over_ui.score_label.text = "Score: {score}".format({"score": score})
	game_over_ui.open()
