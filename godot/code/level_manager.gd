extends Node

@export var levels : Array[PackedScene] = []

var current : Level = null
var parent : Node3D = null

func load(choice: int, parent: Node3D = null) -> void:
	if not current or not parent:
		return

	if (choice >= 0 and choice < levels.size()):
		prints("Loading level", choice)
		if current:
			current.queue_free()
		current = (levels[choice].instantiate())
		parent.add_child(current)
