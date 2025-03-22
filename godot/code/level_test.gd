extends Level


# Main event loop, currently dummy condition and processes input indefinitely
func _main() -> void:
	player = %Blox
	Camera.follow = player
	#Camera.look = player

	#await %Intro1.play()

	%Step1.show()

	_play()
	await player.moved

	bind(player.moved, "moved")
	bind(player.faces, "faces")

	await any(["moved", "faces"])


	%Step1.hide()
	%Arrow0.hide()
	%Arrow1.show()
	%Step2.show()
	await until(player.faces, %Mailbox)
	%Mailbox.highlight.play()
	%Arrow1.hide()
	%Arrow2.show()
	%Step2.hide()

	%Waff1.show_for_critter(%Blox)
	%Waff2.show_for_critter(%Blox)
	%Waff3.show_for_critter(%Blox)

	await until(player.faces, %Chip)
	%Step3.show()
	playing = await until(player.faces, %Blitty)
	%Arrow2.hide()

	await _cutscene()


func _cutscene():
	%Outro.show()
