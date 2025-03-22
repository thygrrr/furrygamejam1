extends Node3D
class_name Level

var player : Player
var playing : bool

var input_buffer : Array[InputEvent] = []

var _bindings : Dictionary[String, Variant] = {}

func _enter_tree() -> void:
	Grid.reset()
	_bindings.clear()


func _ready() -> void:
	for child in $UI.get_children():
		child.hide()

	_main() # run in background


func _main():
	printerr("Level has no _main() function.")


func until(awaitable: Signal, whom: Node) -> bool:
	while true:
		var other = await awaitable
		if whom == other:
			break;
	return false # mild hack, dont have nice semantics for this yet


func bind(from: Signal, slot: String) -> void:
	_bindings[slot] = await from


func all(args : Array[String]):
	for arg in args:
		while not arg in _bindings:
			await get_tree().process_frame

func any(args : Array[String]):
	var solved = false
	while not solved:
		await get_tree().process_frame
		for arg in args:
			if arg in _bindings:
				solved = true

func _play():
	playing = true
	while playing:
		if input_buffer:
			await player._execute(input_buffer.pop_front())
		else:
			await get_tree().process_frame


func _input(event: InputEvent) -> void:
	if event.is_action_type() and event.is_pressed():
		input_buffer.append(event)
