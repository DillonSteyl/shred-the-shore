class_name PlayerSFX
extends Node

@onready var landing: AudioStreamPlayer = $Landing
@onready var explosion: AudioStreamPlayer = $Explode
@onready var whoosh: AudioStreamPlayer = $Whoosh


func land():
	landing.play(0.1)


func explode():
	explosion.play()


func trick():
	whoosh.play(0.1)
