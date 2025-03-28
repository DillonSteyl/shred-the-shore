class_name ScoreManager
extends Node

signal score_changed(new_score: int)

const JUMP_POINTS_PER_SECOND: float = 100

@onready var score: int = 0:
	set = _set_score
@onready var style_manager: StyleManager = $StyleManager


func add_jump(duration: float):
	score += int(JUMP_POINTS_PER_SECOND * duration)


func _set_score(new_score: int):
	score_changed.emit(new_score)
	score = new_score
