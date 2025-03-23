extends Level

@export var moves_par : int = 0
@export var moves_record : int = 0

var moves : int = 0

func count_move() -> void:
	moves += 1

func _main() -> void:
	player = %Blitty
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

	await until(%Blox.faces, %Drinks)
	await until(player.faces, %Drinks)
	%Step1.hide()
	%Drinks.highlight.play()
	playing = false

	await _cutscene()
	prints("Moves taken:", moves)


func _cutscene():
	Music.victory.play()
	await %Outro.play()
	await AppUi.fade_overlay.fade_out()
	await seconds(5)
	await LevelManager.load(4)
	await %ThankYou.play()
	await Music.fade_calm()
	await seconds(2)
	get_tree().change_scene_to_file("res://scenes/main_menu_scene.tscn")
