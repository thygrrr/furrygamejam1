extends Node3D

var player : Player
var playing : bool

var input_buffer : Array[InputEvent] = []

func _enter_tree() -> void:
	Grid.reset()


func _ready() -> void:
	_main() # run in background


# Main event loop, currently dummy condition and processes input indefinitely
func _main() -> void:
	player = %Blox

	%Intro.show()

	_play()
	await player.moved

	%Intro.hide()
	%Tip2.show()

	playing = await _until(player.facing, %Blitty)
	%Intro.hide()

	await _cutscene()
	# await _nextlevel()


func _cutscene():
	%Cutscene.show()


func _until(awaitable: Signal, whom: Node) -> bool:
	while true:
		var other = await awaitable
		if whom == other:
			break;
	return false # mild hack, dont have nice semantics for this yet


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
