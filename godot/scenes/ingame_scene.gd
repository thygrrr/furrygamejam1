extends Node

func _ready() -> void:
	AppUi.fade_overlay.visible = true
	await LevelManager.load(1)

func _input(event) -> void:
	if event.is_action_pressed("pause") and not AppUi.pause_overlay.visible:
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		Music.fade_calm()

		AppUi.pause_overlay.grab_button_focus()
		AppUi.pause_overlay.visible = true
