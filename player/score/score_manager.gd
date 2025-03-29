class_name ScoreManager
extends Node

signal score_changed(new_score: int)
signal score_event_triggered(name: String, score: int, multiplier: float)

const POINTS_TO_STYLE_MODIFIER: float = 0.01
const JUMP_POINTS_PER_SECOND: float = 100

@onready var score: int = 0:
	set = _set_score
@onready var style_manager: StyleManager = $StyleManager


func add_jump(duration: float):
	var points = int(JUMP_POINTS_PER_SECOND * duration)
	var multiplier = style_manager.current_bracket.multiplier
	score += int(points * multiplier)
	style_manager.style += POINTS_TO_STYLE_MODIFIER * score
	score_event_triggered.emit("Air!", points, multiplier)


func collide():
	var points = 1
	var multiplier = style_manager.current_bracket.multiplier
	score += int(points * multiplier)
	style_manager.style += POINTS_TO_STYLE_MODIFIER * score
	score_event_triggered.emit("Destruction!", points, multiplier)


func _set_score(new_score: int):
	score_changed.emit(new_score)
	score = new_score
