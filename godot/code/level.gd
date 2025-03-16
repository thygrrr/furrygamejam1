extends Node3D

var player : Player
var playing : bool

func _enter_tree() -> void:
	Grid.reset()

func _ready() -> void:
	_main()

# Buffer input events
func _input(event: InputEvent) -> void:
	if event.is_action_type() and event.is_pressed():
		input_buffer.append(event)


var input_buffer : Array[InputEvent] = []

# Main event loop, currently dummy condition and processes input indefinitely
func _main() -> void:
	player = %Blox

	_play()

	playing = await _until(player.facing, %Blitty)

	await _cutscene()


func _cutscene():
	%Cutscene.show()


func _until(awaitable, whom: Node) -> bool:
	while true:
		var other = await awaitable
		if other == whom:
			break;
	return false # mild hack, dont have nice semantics for this yet


func _play():
	playing = true
	while playing:
		if input_buffer:
			await player._execute(input_buffer.pop_front())
		else:
			await get_tree().process_frame
