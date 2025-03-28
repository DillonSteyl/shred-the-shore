class_name PlayerStateMachine
extends StateMachine

@export var player: Player

@onready var grounded: PlayerGroundedState = $Grounded
@onready var airbourne: PlayerAirbourneState = $Airbourne
