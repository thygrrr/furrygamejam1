extends Control
class_name PauseOverlay

@onready var resume_button := %ResumeButton
@onready var retry_button := %RetryButton
@onready var menu_container := %MenuContainer


func _ready() -> void:
	resume_button.pressed.connect(_resume)
	retry_button.pressed.connect(_retry)


func grab_button_focus() -> void:
	resume_button.grab_focus()


func load(level : int):
	Music.fade_main()
	visible = false

	await LevelManager.load(level)
	_resume()


func _resume() -> void:
	Music.fade_main()
	get_tree().paused = false
	visible = false


func _retry() -> void:
	visible = false
	await LevelManager.retry()
	_resume()


func _unhandled_input(event):
	if event.is_action_pressed("pause") and visible:
		#get_viewport().set_input_as_handled()
		if menu_container.visible:
			_resume()
