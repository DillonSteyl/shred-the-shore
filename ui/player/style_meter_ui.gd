class_name StyleMeterUI
extends Control

@onready var progress_bar: ProgressBar = $%ProgressBar
@onready var bracket_label: Label = $%BracketLabel
@onready var multiplier_label: Label = $%MultiplierLabel


func _ready() -> void:
	progress_bar.min_value = StyleManager.MIN_STYLE
	progress_bar.max_value = StyleManager.MAX_STYLE


func set_style(new_style: float) -> void:
	progress_bar.value = new_style


func set_bracket(new_bracket: StyleManager.StyleBracket):
	bracket_label.text = new_bracket.name
	multiplier_label.text = "x {multiplier}".format({"multiplier": new_bracket.multiplier})
