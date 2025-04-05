extends Level

@export var moves_par : int = 0
@export var moves_record : int = 0

var moves : int = 0

func count_move() -> void:
	moves += 1

func _main() -> void:
	Music.fade_main()
	player = %Blox
	Camera.follow = player
	Camera.warp()
	%Intro.play()
	player.moved.connect(count_move)
	_play()
	await player.moved
	await player.moved
	%Step1.show()
	%Intro.hide()
	await player.moved
	after(1, %Step1.hide)
	after(2, %Step2.show)

	playing = await until(player.faces, %DoorBar)
	
	await _cutscene1()

	_play()
	%Step3.show()
	await player.moved
	await player.moved
	await player.moved
	await player.moved
	after(1, %Step3.hide)
	after(2, %Step4.show)
	
	playing = await until(player.faces,%DoorWC)

	await _cutscene2()	
	prints("Moves taken:", moves)
	

func _cutscene1():
	%Step1.hide()
	%Step2.hide()
	Music.success.play()
	await seconds(1)
	%DoorBar.highlight.play()
	await %Intermezzo1.play()
	player = %Blitty
	Camera.follow = player
	await %Intermezzo2.play()
	%Blox.hide()

func _cutscene2():
	%Step3.hide()
	%Step4.hide()
	Music.victory.play()
	await seconds(1)
	%DoorWC.highlight.play()
	await AppUi.fade_overlay.fade_out()
	await %Outro.play()
	await seconds(2)
	await LevelManager.load(4)
