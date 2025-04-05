extends Node

@onready var levels : Array[PackedScene] = [
	preload("res://levels/level_test.tscn"),
	preload("res://levels/level_home.tscn"),
	preload("res://levels/level_pool.tscn"),
	preload("res://levels/level_heart.tscn"),
	preload("res://levels/level_bar.tscn"),
	preload("res://levels/level_end.tscn"),
]

var current : Node3D
var current_index : int

var loading: bool

func retry():
	await AppUi.fade_overlay.fade_out()
	self.load(current_index)

func load(choice: int) -> void:
	if loading:
		return
	loading = true
	if (choice >= 0 and choice < levels.size()):
		await AppUi.fade_overlay.fade_out()
		prints("Loading level", choice)
		current_index = choice
		if current:
			current.queue_free()
			current = null
		current = levels[choice].instantiate()
		get_tree().root.add_child(current)
		await get_tree().process_frame
		AppUi.fade_overlay.fade_in()
	loading = false
