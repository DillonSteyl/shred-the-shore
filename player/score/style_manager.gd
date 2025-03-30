class_name StyleManager
extends Node

signal style_changed(new_style: float)
signal bracket_changed(new_bracket: StyleBracket)

const MIN_STYLE: float = 0.0
const MAX_STYLE: float = 100.0
const START_STYLE_DECAY_DELAY: float = 1.0
const END_STYLE_DECAY_DELAY: float = 0.4
const STYLE_DECAY_PER_SECOND: float = 10.0

var style_decay_delay: float = START_STYLE_DECAY_DELAY


class StyleBracket:
	extends RefCounted

	@export var name: String
	@export var style_threshold: float
	@export var multiplier: float
	@export var wave_amplitude: float
	@export var wave_speed: float

	func _init(
		p_name: String,
		p_style_threshold: float,
		p_multiplier: float,
		p_wave_amplitude: float = 30.0,
		p_wave_speed: float = 6.0,
	) -> void:
		name = p_name
		style_threshold = p_style_threshold
		multiplier = p_multiplier
		wave_amplitude = p_wave_amplitude
		wave_speed = p_wave_speed

	func _to_string() -> String:
		return name


@onready var style_brackets: Array[StyleBracket] = [
	StyleBracket.new("Mellow", 0, 1.0),
	StyleBracket.new("Clean", 20, 1.2, 40, 8),
	StyleBracket.new("Slick!", 40, 1.5, 50, 9),
	StyleBracket.new("Gnarly!", 60, 2.0, 60, 10),
	StyleBracket.new("Radical!!", 80, 2.5, 70, 11),
	StyleBracket.new("Astonishing!!!", 95, 3.0, 80, 12),
]
@onready var style_brackets_descending: Array[StyleBracket] = []
@onready var current_bracket: StyleBracket = style_brackets[0]
@onready var decay_enabled: bool = true
@onready var style_decay_timer: Timer = Timer.new()
@onready var style: float = 0:
	set = _set_style


func _ready() -> void:
	style_brackets_descending = style_brackets.duplicate()
	style_brackets_descending.reverse()

	add_child(style_decay_timer)
	style_decay_timer.one_shot = true
	style_decay_timer.wait_time = style_decay_delay
	style_decay_timer.start()

	style_changed.emit(style)
	bracket_changed.emit(current_bracket)

	var tween = get_tree().create_tween()
	tween.tween_property(
		self, "style_decay_delay", END_STYLE_DECAY_DELAY, Constants.DIFFICULTY_INCREASE_DURATION
	)


func get_current_bracket() -> StyleBracket:
	for _bracket in style_brackets_descending:
		if style >= _bracket.style_threshold:
			return _bracket

	return style_brackets[0]


func _physics_process(delta: float) -> void:
	if style_decay_timer.is_stopped() and decay_enabled:
		style -= STYLE_DECAY_PER_SECOND * delta


func _set_style(new_style: float):
	if new_style > style:
		# style increased - delay the decay
		style_decay_timer.wait_time = style_decay_delay
		style_decay_timer.start()

	style = clamp(new_style, MIN_STYLE, MAX_STYLE)
	current_bracket = get_current_bracket()
	style_changed.emit(new_style)
	bracket_changed.emit(current_bracket)
