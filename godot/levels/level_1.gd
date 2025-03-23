extends Level

@export var moves_par : int = 0
@export var moves_record : int = 0

var moves : int = 0

func count_move() -> void:
	moves += 1

func blitty_sees(other: Interactable):
	if other == %Dado:
		%BlittySees.play()

func _main() -> void:
	player = %Blox
	Camera.follow = player
	Camera.warp()

	player.sees.connect(blitty_sees)
	player.moved.connect(count_move)

	%Intro.play()

	_play()

	%Step1.show()
	await player.moved

	#await any2(player.moved, player.faces, %Blitty.faces)
	%Step1.hide()
	%Arrow0.hide()
	%Arrow1.show()
	%Step2.show()

	await player.moved
	await player.moved
	%Intro.hide()


	await until(player.faces, %Mailbox)
	%Mail.play()
	%Mailbox.highlight.play()
	Music.success.play()
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
	Music.victory.play()
	await %Outro.play()
	#Music.fade_main()
	await AppUi.fade_overlay.fade_out()
	await seconds(2)
	await LevelManager.load(2)
