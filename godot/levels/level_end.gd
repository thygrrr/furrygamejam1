extends Level

@export var moves_par : int = 0
@export var moves_record : int = 0

var solved : bool
	
var moves : int = 0

func count_move() -> void:
	moves += 1

func blitty_faces(other: Interactable):
	if other == %Blox:
		solved = true

func blox_faces(other: Interactable):
	if other == %Blitty:
		solved = true

func _main() -> void:
	player = %Blox
	Camera.follow = player
	Camera.warp()
	Camera.soft()

	%Blox.faces.connect(blox_faces)
	%Blox.moved.connect(count_move)
	%Blitty.faces.connect(blitty_faces)
	%Blitty.moved.connect(count_move)

	%Intro.play()

	_play()
	
	while !solved:
		if player == %Blitty:
			player = %Blox
		else:
			player = %Blitty
		Camera.follow = player
		await player.moved
		await seconds(0.1)
		%Step1.show()

	playing = false		

	%Intro.hide()
	%Step1.hide()

	prints("Moves taken:", moves)
	await _cutscene()


func _input(event: InputEvent) -> void:
	super(event)
	if Input.is_key_label_pressed(KEY_P):
		solved = true
		pass
		
func _cutscene():
	Camera.follow = null
	Music.victory.play()
	%Step1.hide()
	await %Outro.play()
	await AppUi.fade_overlay.fade_out()
	await seconds(4)
	%ThankYou.show()
	await %ThankYou.play()
	$Ambience.stop()
	await seconds(2)
	get_tree().change_scene_to_file.call_deferred("res://scenes/main_menu_scene.tscn")
