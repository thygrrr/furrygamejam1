extends Node2D

@export var game_scene:PackedScene
@export var settings_scene:PackedScene

@onready var overlay := %FadeOverlay
@onready var new_game_button := %NewGameButton
@onready var settings_button := %SettingsButton

var next_scene = game_scene
var new_game = true

func _ready() -> void:
	overlay.visible = true
	new_game_button.disabled = game_scene == null
	settings_button.disabled = settings_scene == null

	# connect signals
	new_game_button.pressed.connect(_on_play_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
#	overlay.on_complete_fade_out.connect(_on_fade_overlay_on_complete_fade_out)
	new_game_button.grab_focus()

func _on_settings_button_pressed() -> void:
	new_game = false
	next_scene = settings_scene
	overlay.fade_out()

func _on_play_button_pressed() -> void:
	new_game = true
	next_scene = game_scene
	await overlay.fade_out()
	await LevelManager.load(1)
	queue_free()
