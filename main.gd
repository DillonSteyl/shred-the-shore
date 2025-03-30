class_name Main
extends Node

@onready var game_scene = ResourceLoader.load(
	"res://world/infinite_level.tscn", "", ResourceLoader.CACHE_MODE_IGNORE_DEEP
)
@onready var main_menu_ui = ResourceLoader.load(
	"res://ui/main_menu/main_menu.tscn", "", ResourceLoader.CACHE_MODE_IGNORE
)
@onready var main_menu_scene = ResourceLoader.load(
	"res://ui/main_menu/main_menu_scene.tscn", "", ResourceLoader.CACHE_MODE_IGNORE
)

@onready var world: Node3D = $World
@onready var ui: Control = $UI


func _ready() -> void:
	go_to_menu()


func go_to_menu() -> void:
	set_world(main_menu_scene.instantiate())

	var main_menu: MainMenu = main_menu_ui.instantiate()
	set_ui(main_menu)
	main_menu.play_button.pressed.connect(play_game)


func set_ui(ui_node: Control) -> void:
	for child in ui.get_children():
		child.queue_free()

	if ui_node:
		ui.mouse_filter = Control.MOUSE_FILTER_STOP
		ui.add_child(ui_node)


func set_world(world_node: Node3D) -> void:
	for child in world.get_children():
		child.queue_free()

	if world_node:
		world.add_child(world_node)


func play_game() -> void:
	set_ui(null)
	set_world(null)

	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame

	ui.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var game_world = game_scene.instantiate()
	set_world(game_world)

	var player = game_world.get_node("Player") as Player
	player.ui.game_over_ui.play_again_button.pressed.connect(play_game)
	player.ui.game_over_ui.exit_button.pressed.connect(go_to_menu)
