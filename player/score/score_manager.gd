class_name ScoreManager
extends Node

signal score_changed(new_score: int)
signal score_event_triggered(name: String, score: int, multiplier: float)

const POINTS_TO_STYLE_MODIFIER: float = 0.05
const JUMP_POINTS_PER_SECOND: float = 60

@onready var score: int = 0:
	set = _set_score
@onready var style_manager: StyleManager = $StyleManager


func add_jump(duration: float):
	var points = int(JUMP_POINTS_PER_SECOND * duration)
	_add_points(points, "Air!")


func collide():
	_add_points(10, "Destruction!")


func trick():
	_add_points(100, "Sweet Trick!")


func _add_points(points: int, event_name: String):
	style_manager.style += POINTS_TO_STYLE_MODIFIER * points
	var multiplier = style_manager.current_bracket.multiplier
	score += int(points * multiplier)
	score_event_triggered.emit(event_name, points, multiplier)
	$ScoreAudio.pitch_scale = randf_range(1.0, 1.2)
	$ScoreAudio.play()


func _set_score(new_score: int):
	score_changed.emit(new_score)
	score = new_score
