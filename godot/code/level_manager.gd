extends Node

var levels : Array[PackedScene] = []
var l0 : PackedScene = preload("res://levels/level_test.tscn")
var l1 : PackedScene = preload("res://levels/level_1.tscn")
var l2 : PackedScene = preload("res://levels/level_2.tscn")
var l3 : PackedScene = preload("res://levels/level_3.tscn")

var current : Node3D
var current_index : int

func _ready() -> void:
	levels = [l0, l1, l2, l3]

func retry():
	await AppUi.fade_overlay.fade_out()
	self.load(current_index)

func load(choice: int) -> void:
	if (choice >= 0 and choice < levels.size()):
		await AppUi.fade_overlay.fade_out()
		prints("Loading level", choice)
		current_index = choice
		if current:
			current.queue_free()
			current = null
		current = levels[choice].instantiate()
		get_tree().root.add_child(current)
		AppUi.fade_overlay.fade_in()
