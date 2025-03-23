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

	player.moved.connect(count_move)
	_play()

	playing = await until(player.faces, %BilliardTable)
	%BilliardTable.highlight.play()

	await _cutscene()
	prints("Moves taken:", moves)


func _cutscene():
	%Outro.show()
	await seconds(3)
	Music.victory.play()
	await LevelManager.load(3)
