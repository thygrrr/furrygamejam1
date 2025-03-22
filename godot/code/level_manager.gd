extends Node

@export var levels : Array[PackedScene] = []

var current : Node3D

func load(choice: int) -> void:
	if (choice >= 0 and choice < levels.size()):
		prints("Loading level", choice)
		if current:
			current.queue_free()
			current = null
		current = levels[choice].instantiate()
		get_tree().root.add_child(current)
		await AppUi.fade_overlay.fade_in()
