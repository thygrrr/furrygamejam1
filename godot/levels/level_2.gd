extends Level

@export var moves_par : int = 0
@export var moves_record : int = 0

var moves : int = 0

func count_move() -> void:
	moves += 1

func _main() -> void:
	player = %Blox
	Camera.follow = player
	Camera.warp()
	%Intro.play()

	player.moved.connect(count_move)
	_play()
	await player.moved
	%Step1.show()
	await player.moved
	await player.moved
	await player.moved
	await player.moved
	await player.moved
	%Intro.hide()

	playing = await until(player.faces, %BilliardTable)
	%Step1.hide()

	await _cutscene()
	prints("Moves taken:", moves)


func _cutscene():
	Music.victory.play()
	await seconds(1)
	%BilliardTable.highlight.play()
	await %Outro.play()
	await AppUi.fade_overlay.fade_out()
	await seconds(2)
	await LevelManager.load(3)
