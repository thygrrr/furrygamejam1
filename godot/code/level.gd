extends Node3D
class_name MyClass

static func TheFunction() -> void:
	pass

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

static func global_something() -> void:
	pass


# Main event loop, currently dummy condition and processes input indefinitely
func _main() -> void:
	player = %Blox


	#await %Intro1.play()

	%Step1.show()

	_play()
	await player.moved

	bind(player.moved, "moved")
	bind(player.faces, "faces")

	await any(["moved", "faces"])


	%Step1.hide()
	%Step2.show()
	await until(player.faces, %Mailbox)
	%Step2.hide()

	await until(player.faces, %Chip)

	%Step3.show()
	%Waff.show_for_critter(%Blox)
	playing = await until(player.faces, %Blitty)

	await _cutscene()
	# await _nextlevel()

func _cutscene():
	%Outro.show()


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
