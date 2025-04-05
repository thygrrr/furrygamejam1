extends Level

@export var moves_par : int = 0
@export var moves_record : int = 0

var moves : int = 0

func count_move() -> void:
	moves += 1

var blox_complete : bool = false
func blox_faces(other: Node3D):
	blox_complete = other == %Drinks

var blitty_complete : bool = false
func blitty_faces(other: Node3D):
	blitty_complete = other == %Drinks

func _main() -> void:
	Music.fade_main()
	player = %Blitty
	Camera.follow = player
	Camera.warp()

	%Intro.play()

	player.moved.connect(count_move)
	_play()
	%Blox.faces.connect(blox_faces)
	%Blitty.faces.connect(blitty_faces)

	await player.moved
	%Step1.show()
	await player.moved
	await player.moved
	await player.moved
	await player.moved
	await player.moved
	%Intro.hide()

	while (not blox_complete) or (not blitty_complete):
		await process

	%Step1.hide()
	%Drinks.highlight.play()
	playing = false

	await _cutscene()
	prints("Moves taken:", moves)


func _cutscene():
	Music.victory.play()
	await %Outro.play()
	await AppUi.fade_overlay.fade_out()
	await seconds(2)
	await Music.fade_calm()
	await LevelManager.load(5)
