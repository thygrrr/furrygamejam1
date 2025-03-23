extends Node2D

@export var game_scene:PackedScene
@export var settings_scene:PackedScene

@onready var new_game_button := %NewGameButton
@onready var settings_button := %SettingsButton

var next_scene = game_scene
var new_game = true

func _ready() -> void:
	new_game_button.disabled = game_scene == null
	settings_button.disabled = settings_scene == null

	# connect signals
	new_game_button.pressed.connect(_on_play_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	new_game_button.grab_focus()
	AppUi.fade_overlay.fade_in.call_deferred()

func _on_settings_button_pressed() -> void:
	settings_button.disabled = true
	new_game = false
	next_scene = settings_scene
	await AppUi.fade_overlay.fade_out()
	get_tree().change_scene_to_packed.call_deferred(next_scene)

func _on_play_button_pressed() -> void:
	new_game_button.disabled = true
	new_game = true
	next_scene = game_scene
	await AppUi.fade_overlay.fade_out()
	get_tree().change_scene_to_packed.call_deferred(next_scene)
