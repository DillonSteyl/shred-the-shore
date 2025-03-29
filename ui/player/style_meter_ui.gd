class_name StyleMeterUI
extends Control

@onready var progress_bar: ProgressBar = $%ProgressBar
@onready var bracket_label: RichTextLabel = $%BracketLabel
@onready var multiplier_label: Label = $%MultiplierLabel


func _ready() -> void:
	progress_bar.min_value = StyleManager.MIN_STYLE
	progress_bar.max_value = StyleManager.MAX_STYLE


func set_style(new_style: float) -> void:
	progress_bar.value = new_style


func set_bracket(new_bracket: StyleManager.StyleBracket):
	bracket_label.text = "[wave amp={amp} freq={freq} connected=1]{name}[/wave]".format(
		{
			"name": new_bracket.name,
			"amp": new_bracket.wave_amplitude,
			"freq": new_bracket.wave_speed
		}
	)
	multiplier_label.text = "x {multiplier}".format({"multiplier": new_bracket.multiplier})
