class_name Utils
extends Node


static func round_to_dec(num: float, digit: int):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
