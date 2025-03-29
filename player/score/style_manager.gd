class_name StyleManager
extends Node

signal style_changed(new_style: float)
signal bracket_changed(new_bracket: StyleBracket)

const MIN_STYLE: float = 0.0
const MAX_STYLE: float = 100.0
const STYLE_DECAY_DELAY: float = 2.0
const STYLE_DECAY_PER_SECOND: float = 8.0


class StyleBracket:
	extends RefCounted

	@export var name: String
	@export var style_threshold: float
	@export var multiplier: float

	func _init(p_name: String, p_style_threshold: float, p_multiplier: float) -> void:
		name = p_name
		style_threshold = p_style_threshold
		multiplier = p_multiplier

	func _to_string() -> String:
		return name


@onready var style_brackets: Array[StyleBracket] = [
	StyleBracket.new("Mellow", 0, 1.0),
	StyleBracket.new("Clean", 10, 1.2),
	StyleBracket.new("Slick!", 20, 1.5),
	StyleBracket.new("Gnarly!", 40, 2.0),
	StyleBracket.new("Radical!!", 80, 2.5),
	StyleBracket.new("Astonishing!!!", 95, 3.0),
]
@onready var style_brackets_descending: Array[StyleBracket] = []
@onready var current_bracket: StyleBracket = style_brackets[0]
@onready var style: float = 0:
	set = _set_style
@onready var style_decay_timer: Timer = Timer.new()


func _ready() -> void:
	style_brackets_descending = style_brackets.duplicate()
	style_brackets_descending.reverse()

	add_child(style_decay_timer)
	style_decay_timer.one_shot = true
	style_decay_timer.wait_time = STYLE_DECAY_DELAY
	style_decay_timer.start()


func get_current_bracket() -> StyleBracket:
	for _bracket in style_brackets_descending:
		if style >= _bracket.style_threshold:
			return _bracket

	return style_brackets[0]


func _physics_process(delta: float) -> void:
	if style_decay_timer.is_stopped():
		style -= STYLE_DECAY_PER_SECOND * delta


func _set_style(new_style: float):
	if new_style > style:
		# style increased - delay the decay
		style_decay_timer.start()

	style = clamp(new_style, MIN_STYLE, MAX_STYLE)
	current_bracket = get_current_bracket()
	style_changed.emit(new_style)
	bracket_changed.emit(current_bracket)
