extends Control

@onready var return_button := %ReturnButton

func _ready():
	return_button.pressed.connect(_on_return_button_pressed)
	return_button.grab_focus()
	AppUi.fade_overlay.fade_in.call_deferred()


func _on_return_button_pressed():
	await AppUi.fade_overlay.fade_out()
	get_tree().change_scene_to_file("res://scenes/main_menu_scene.tscn")
