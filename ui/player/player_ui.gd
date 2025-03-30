class_name PlayerUI
extends Control

@onready var hud = $HUD
@onready var score_label: Label = $%ScoreLabel
@onready var score_event_ui: ScoreEventUI = $%ScoreEvent
@onready var style_meter_ui: StyleMeterUI = $%StyleMeterUI
@onready var game_over_ui: GameOverUI = $GameOverUI


func update_score(new_score: int):
	score_label.text = "{score}".format({"score": new_score})


func show_game_over(score: int, bracket: StyleManager.StyleBracket):
	hud.queue_free()
	game_over_ui.score_label.text = "Score: {score}".format({"score": score})
	game_over_ui.bracket_label.text = (
		"you were [wave amp={amp} freq={freq} connected=1]{name}[/wave]"
		. format({"name": bracket.name, "amp": bracket.wave_amplitude, "freq": bracket.wave_speed})
	)
	game_over_ui.open()
