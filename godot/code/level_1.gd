extends Level

@export var moves_par : int = 0
@export var moves_record : int = 0

var moves : int = 0

func count_move() -> void:
	moves += 1

func _main() -> void:
	LevelManager.current = self # Hack :)

	player = %Blox
	Camera.follow = player

	player.moved.connect(count_move)

	%Step1.show()

	_play()
	await player.moved

#	bind(player.moved, "moved")
#	bind(player.faces, "faces")

#	await any(["moved", "faces"])

	%Step1.hide()
	%Arrow0.hide()
	%Arrow1.show()
	%Step2.show()

	await until(player.faces, %Mailbox)

	%Mailbox.highlight.play()
	%Arrow1.hide()
	%Arrow2.show()
	%Step2.hide()

	%Step3.show()
	%Waff1.show_for_critter(%Blox)
	%Waff2.show_for_critter(%Blox)

	playing = await until(player.faces, %Blitty)
	%Arrow2.hide()

	await _cutscene()
	prints("Moves taken:", moves)


func _cutscene():
	%Outro.show()
	get_parent().fade_overlay.fade_out()
