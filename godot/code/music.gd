extends Node

@onready var victory = $Victory
@onready var success = $Success

@onready var calm = $Calm
@onready var main = $Main

var mtween : TweensGdHandle
var ctween : TweensGdHandle
func fade_main() -> void:
	if mtween:
		mtween.cancel()
	if ctween:
		ctween.cancel()
	mtween = Tweens.play(main, Tweens.property(^"volume_db", 0.0, 1.0))
	ctween = Tweens.play(calm, Tweens.property(^"volume_db", -80.0, 5.0))

func fade_calm() -> void:
	if mtween:
		mtween.cancel()
	if ctween:
		ctween.cancel()
	ctween = Tweens.play(calm, Tweens.property(^"volume_db", 0.0, 1.0))
	mtween = Tweens.play(main, Tweens.property(^"volume_db", -80.0, 5.0))
