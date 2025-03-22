extends Level


func _main() -> void:
	player = %Blox
	Camera.follow = player

	_play()
