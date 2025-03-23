extends Node3D
class_name Level

signal process

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

	_main.call_deferred() # run in background
	LevelManager.current = self


func _main():
	printerr("Level has no _main() function.")

func seconds(amount: float):
	await get_tree().create_timer(amount).timeout

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
			await process


#func any2(a : Signal, b : Signal = Signal(), c : Signal = Signal(), d : Signal = Signal(), e : Signal = Signal()):
	#if b:
	#	pass
	#pass


func any(args : Array[String]):
	var solved = false
	while not solved:
		await process
		for arg in args:
			if arg in _bindings:
				solved = true


func _play():
	playing = true
	while playing:
		if input_buffer:
			await player.execute(input_buffer.pop_front())
		else:
			await process


func _process(_delta: float):
	process.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_type() and event.is_pressed():
		input_buffer.append(event)
